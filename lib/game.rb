class Game
  attr_accessor :player_name, :secret_code, :user_code, :attempts, :hints, :difficulty_name

  def initialize(player_name, difficulty)
    @stats = Statistic.stats
    @player_name = player_name
    @difficulty_name = DIFFICULTIES.key(difficulty).to_s
    @attempts = difficulty[:attempts]
    @hints = difficulty[:hints]
  end

  def give_hint
    @hints -= 1
    @secret_code.sample
  end

  def run
    @secret_code = generate_code
  end

  def generate_code
    Array.new(4) { rand(1..6) }
  end

  def result(response)
    @user_code = response.each_char.map(&:to_i)
    @attempts -= 1
    return '++++' if @secret_code == user_code

    create_response
  end

  def save_result
    @stats.push(Statistic.generate_stats(self))
    DbUtils.add(DB, @stats)
  end

  def won?(result)
    result == '++++'
  end

  def lost?
    attempts.zero?
  end

  private

  def create_response
    @pluses = ''
    @minuses = ''
    @spaces = ''
    check_the_code
    "#{@pluses}#{@minuses}#{@spaces}"
  end

  def check_the_code
    @secret_code_clone = @secret_code.clone
    (4 - Matching.matches(self).length).times { @spaces += ' ' }
    Matching.matches(self).each do |match|
      if @user_code[@secret_code_clone.index(match)] == match
        @pluses += '+'
      else
        @minuses += '-'
      end
      remove_verified_number(match)
    end
  end

  def remove_verified_number(number)
    @user_code[@user_code.index(number)] = 0
    @secret_code_clone[@secret_code_clone.index(number)] = 0
  end
end
