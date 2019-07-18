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
      @user_code = response.each_char.map(&:to_i)
      @attempts -= 1
      return '++++' if @secret_code == user_code

      create_response
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

    def matches
      user_code_clone = @user_code.clone
      matches = @secret_code.map do |number|
        user_code_clone.find do |user_number|
          user_code_clone.delete_at(user_code_clone.index(user_number)) if user_number == number
        end
      end
      matches.compact! || matches
    end

    def create_response
      @pluses = ''
      @minuses = ''
      @spaces = ''
      check_the_code
      "#{@pluses}#{@minuses}#{@spaces}"
    end

    def check_the_code
      @secret_code_clone = @secret_code.clone
      (4 - matches.length).times { @spaces += ' ' }
      matches.each do |match|
        if @user_code[@secret_code_clone.index(match)] == match
          @pluses += '+'
        else
          @minuses += '-'
        end
        remove_verified_number(match)
      end
    end

    def remove_verified_number(number)
      @user_code[@user_code.index(number)] = 0
      @secret_code_clone[@secret_code_clone.index(number)] = 0
    end
  end
end
