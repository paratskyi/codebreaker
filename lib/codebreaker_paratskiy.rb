require 'codebreaker_paratskiy/version'
# require 'codebreaker/game'
require 'pry'

module CodebreakerParatskiy
  class Error < StandardError; end

  class Game
    attr_accessor :secret_code, :user_code, :attempts, :hints

    def initialize
      @secret_code = []

      @attempts = 0
      @hints = 0

      
    end

    def give_hint
      secret_code.sample unless @hints.zero?
      @hints -= 1
    end

    def run
      @secret_code = generate_code
      @user_code = []
    end

    def generate_code
      Array.new(4) { generate_number }
    end

    def generate_number
      rand(1..6)
    end

    def matches(user_code)
      @matches = []
      user_code_clone = user_code.clone
      @secret_code.each do |number|
        catch :find_match do
          user_code_clone.each do |user_number|
            @matches.push(user_code_clone.delete_at(user_code_clone.index(user_number))) if number == user_number
            throw :find_match if number == user_number
          end
        end
      end
      @matches
    end

    def check_the_code(user_code)
      @pluses = ''
      @minuses = ''
      @spaces = ''
      secret_code_clone = @secret_code.clone
      matches(user_code).each do |match|
        if secret_code_clone.find_index(match).nil?
          @minuses += '-'
          next
        end
        if secret_code_clone[secret_code_clone.find_index(match)] == user_code[secret_code_clone.find_index(match)]
          @pluses += '+'
          secret_code_clone[secret_code_clone.find_index(match)] = nil
          user_code[user_code.find_index(match)] = nil
        else
          secret_code_clone[secret_code_clone.find_index(match)] = nil
          user_code[user_code.find_index(match)] = nil
          redo
        end
      end
    end

    def result(user_code)
      @attempts -= 1
      if @secret_code == user_code
        return '++++'
      else
        check_the_code(user_code)
      end
      "#{@pluses}#{@minuses}#{@spaces}"
    end
  end
end

# puts CodebreakerParatskiy::Game.new([1, 2, 3, 4], [1, 2, 3, 4]).show_result
# puts CodebreakerParatskiy::Game.new([1, 2, 3, 4], [3, 1, 2,4]).show_result
# puts CodebreakerParatskiy::Game.new([6, 5, 4, 3], [6, 6, 6, 6]).show_result

# game = CodebreakerParatskiy::Game.new

# game.start

# puts game.secret_code
