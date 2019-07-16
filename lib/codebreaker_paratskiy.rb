require 'codebreaker_paratskiy/version'
require 'pry'

module CodebreakerParatskiy
  class Error < StandardError; end

  class Game
    attr_accessor :player_name, :secret_code, :user_code, :attempts, :hints, :selected_difficulty

    def initialize(player_name, selected_difficulty)
      @stats = DbUtils.get(DB)
      @player_name = player_name
      @selected_difficulty = selected_difficulty
      define_difficulty
      @pluses = ''
      @minuses = ''
      @spaces = ''
    end

    def give_hint
      @hints -= 1
      @secret_code.sample
    end

    def run
      @secret_code = generate_code
    end

    def generate_code
      Array.new(4) { rand(1..6) }
    end

    def result(response)
      user_code = response.each_char.map(&:to_i)
      @attempts -= 1
      return '++++' if @secret_code == user_code

      check_the_code(user_code)
    end

    def save_result
      @stats.push(generate_stats)
      DbUtils.add(DB, @stats)
    end

    def define_difficulty
      case @selected_difficulty
      when 'easy' then @attempts, @hints = DIFFICULTY[:easy]
      when 'medium' then @attempts, @hints = DIFFICULTY[:medium]
      when 'hell' then @attempts, @hints = DIFFICULTY[:hell]
      else return false
      end
      @attempts_total = @attempts
      @hints_total = @hints
    end

    private

    def generate_stats
      {
        name: @player_name,
        difficulty: @selected_difficulty,
        attempts_total: @attempts_total,
        attempts_used: @attempts_total - @attempts,
        hints_total: @hints_total,
        hints_used: @hints_total - @hints
      }
    end

    def sort_stats
      @stats.sort_by { |player| [player[:attempts_total], player[:attempts_used], player[:hints_used]] }
    end

    def matches(user_code)
      user_code_clone = user_code.clone
      matches = @secret_code.map do |number|
        user_code_clone.find do |user_number|
          user_code_clone.delete_at(user_code_clone.index(user_number)) if user_number == number
        end
      end
      matches.compact! || matches
    end

    def check_the_code(user_code)
      matches(user_code).each do |match|
        @pluses += '+' if secret_code.index(match) == user_code.index(match)
        @minuses += '-' if secret_code.index(match) != user_code.index(match)
      end
      (4 - matches(user_code).length).times { @spaces += 'x' }
      "#{@pluses}#{@minuses}#{@spaces}"
    end
  end
end
