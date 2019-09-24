class CurrentGame
  def initialize(game)
    @@game = game
  end

  def self.game
    @@game
  end
end
