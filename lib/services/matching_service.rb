module Matching
  def self.matches(game)
    user_code_clone = game.user_code.clone
    matches = game.secret_code.map do |number|
      user_code_clone.find do |user_number|
        user_code_clone.delete_at(user_code_clone.index(user_number)) if user_number == number
      end
    end
    matches.compact! || matches
  end

  def self.create_response(game)
    @pluses = ''
    @minuses = ''
    @spaces = ''
    check_the_code(game)
    "#{@pluses}#{@minuses}#{@spaces}"
  end

  def self.check_the_code(game)
    @secret_code_clone = game.secret_code.clone
    (4 - matches(game).length).times { @spaces += ' ' }
    matches(game).each do |match|
      if same_position?(game, match)
        @pluses += '+'
      else
        @minuses += '-'
      end
      remove_verified_number(match, game)
    end
  end

  def self.same_position?(game, match)
    [game.user_code[@secret_code_clone.index(match)], @secret_code_clone[game.user_code.index(match)]].include? match
  end

  def self.remove_verified_number(number, game)
    game.user_code[game.user_code.index(number)] = 0
    @secret_code_clone[@secret_code_clone.index(number)] = 0
  end
end
