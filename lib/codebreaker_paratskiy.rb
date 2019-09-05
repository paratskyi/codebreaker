require_relative 'game'
module CodebreakerParatskiy
  def self.run_game(name, difficulty)
    game = Game.new(name, difficulty)
    game.run
    game
  end
end
