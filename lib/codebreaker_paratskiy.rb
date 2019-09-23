require_relative 'game'
module CodebreakerParatskiy
  def self.run_game(name = DEFAULT_NAME, difficulty = DIFFICULTIES[:default])
    game = Game.new(name, difficulty)
    game.run
    game
  end
end
