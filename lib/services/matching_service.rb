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
end
