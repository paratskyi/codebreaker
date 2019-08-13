module Statistic
  def self.generate_stats(game)
    puts game.difficulty
    {
      name: game.player_name,
      difficulty: game.difficulty,
      attempts_total: DIFFICULTY[game.difficulty.to_sym][:attempts],
      attempts_used: DIFFICULTY[game.difficulty.to_sym][:attempts] - game.attempts,
      hints_total: DIFFICULTY[game.difficulty.to_sym][:hints],
      hints_used: DIFFICULTY[game.difficulty.to_sym][:hints] - game.hints
    }
  end

  def self.sort_stats
    stats.sort_by { |player| [player[:attempts_total], player[:attempts_used], player[:hints_used]] }
  end

  def self.stats
    DbUtils.get(DB)
  end
end
