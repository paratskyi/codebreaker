module Statistic
  def self.generate_stats(game)
    {
      name: game.player_name,
      difficulty: game.difficulty,
      attempts_total: DIFFICULTY[game.difficulty][:attempts],
      attempts_used: DIFFICULTY[game.difficulty][:attempts] - game.attempts,
      hints_total: DIFFICULTY[game.difficulty][:hints],
      hints_used: DIFFICULTY[game.difficulty][:hints] - game.hints
    }
  end

  def self.sort_stats
    stats.sort_by { |player| [player[:attempts_total], player[:attempts_used], player[:hints_used]] }
  end

  def self.stats
    DbUtils.get(DB)
  end
end
