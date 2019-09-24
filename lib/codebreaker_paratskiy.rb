require_relative 'game'
module CodebreakerParatskiy
  def self.run_game(name, difficulty)
    CurrentGame.new(Game.new(name, difficulty))
    CurrentGame.game.run
  end
end
