require_relative 'services/matching_service'
require_relative 'services/statistic_service'
class Game
  attr_accessor :player_name, :secret_code, :user_code, :attempts, :hints, :difficulty_name
  attr_reader :stats, :secret_code_for_hint

  def initialize(player_name, difficulty)
    @stats = Statistic.stats
    @player_name = player_name
    @difficulty_name = difficulty
    @attempts = DIFFICULTIES[difficulty.to_sym][:attempts]
    @hints = DIFFICULTIES[difficulty.to_sym][:hints]
    @db = DB
    @secret_code_for_hint = []
  end

  def use_hint
    @hints -= 1
    secret_code_for_hint.sort_by! { rand }.pop
  end

  def run
    @secret_code = generate_code
    @secret_code_for_hint = @secret_code.clone
  end

  def generate_code
    Array.new(4) { rand(1..6) }
  end

  def result(response)
    @user_code = response.each_char.map(&:to_i)
    @attempts -= 1
    return WINNING_RESULT if @secret_code == user_code

    Matching.new(self).create_response
  end

  def save_result
    @stats.push(Statistic.generate_stats)
    DbUtils.add(@db, stats)
  end

  def won?(result)
    result == WINNING_RESULT
  end

  def lost?
    attempts.zero?
  end
end
