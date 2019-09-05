class Matching
  attr_reader :game

  def initialize(game)
    @game = game
  end

  def create_response
    @pluses = ''
    @minuses = ''
    check_the_code
    "#{@pluses}#{@minuses}"
  end

  def exact_matches
    exact_matches = []
    game.secret_code.each_index do |index|
      if current_secret_number(index) == current_user_number(index)
        exact_matches.push(current_secret_number(index))
        remove_verified_number(current_user_number(index))
      end
    end
    exact_matches
  end

  def rest_matches
    @secret_code_clone & game.user_code
  end

  def current_secret_number(index)
    game.secret_code.at(index)
  end

  def current_user_number(index)
    game.user_code.at(index)
  end

  def check_the_code
    @secret_code_clone = game.secret_code.clone
    exact_matches.length.times { @pluses += '+' }
    rest_matches.compact.length.times { @minuses += '-' }
  end

  def remove_verified_number(number)
    game.user_code[game.user_code.index(number)] = nil
    @secret_code_clone[@secret_code_clone.index(number)] = nil
  end
end
