require 'codebreaker_paratskiy/version'
# require 'codebreaker/game'
require 'pry'

module CodebreakerParatskiy
  class Error < StandardError; end

  class Game
    attr_accessor :secret_code, :user_code, :attempts, :hints

    def initialize(attempts, hints)
      @secret_code = []
      @attempts = attempts
      @hints = hints
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
      if @secret_code == user_code
        return '++++'
      else
        check_the_code(user_code)
      end

      "#{@pluses}#{@minuses}#{@spaces}"
    end

    private

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
  end
end
