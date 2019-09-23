require_relative '../utils/db_utils'
require_relative '../config/constants'
class Statistic
  attr_reader :game

  def self.generate_stats(game)
    {
      name: game.player_name,
      difficulty: game.difficulty_name,
      attempts_total: DIFFICULTIES[game.difficulty_name.to_sym][:attempts],
      attempts_used: DIFFICULTIES[game.difficulty_name.to_sym][:attempts] - game.attempts,
      hints_total: DIFFICULTIES[game.difficulty_name.to_sym][:hints],
      hints_used: DIFFICULTIES[game.difficulty_name.to_sym][:hints] - game.hints,
      date: Time.now
    }
  end

  def self.sort_stats
    stats.sort_by { |player| [player[:attempts_total], player[:attempts_used], player[:hints_used]] }
  end

  def self.stats
    DbUtils.get(DB) || []
  end
end
