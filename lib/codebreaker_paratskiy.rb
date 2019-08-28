require 'pry'
require_relative '../dependencies'

module CodebreakerParatskiy
  def self.run_game(name, difficulty)
    game = Game.new(name, difficulty)
    game.run
    game
  end
end
