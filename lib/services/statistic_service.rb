require_relative '../utils/db_utils'
require_relative '../config/constants'
class Statistic
  class << self
    def generate_stats
      {
        name: player_name,
        difficulty: difficulty_name,
        total_attempts: total_attempts,
        used_attempts: used_attempts,
        total_hints: total_hints,
        used_hints: used_hints,
        date: Time.now
      }
    end

    def sort_stats
      stats.sort_by { |player| [player[:total_attempts], player[:used_attempts], player[:used_hints]] }
    end

    def stats
      DbUtils.get(DB) || []
    end

    def total_attempts
      DIFFICULTIES[game.difficulty_name.to_sym][:attempts]
    end

    def used_attempts
      DIFFICULTIES[game.difficulty_name.to_sym][:attempts] - game.attempts
    end

    def total_hints
      DIFFICULTIES[game.difficulty_name.to_sym][:hints]
    end

    def used_hints
      DIFFICULTIES[game.difficulty_name.to_sym][:hints] - game.hints
    end

    def difficulty_name
      game.difficulty_name
    end

    def player_name
      game.player_name
    end

    def game
      CurrentGame.game
    end
  end
end
