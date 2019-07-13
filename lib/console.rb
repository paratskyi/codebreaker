class Console
  include CodebreakerParatskiy
  include Validating
  include Output
  attr_accessor :player_name, :user_code

  DB = 'stats.yml'.freeze

  DIFFICULTY = {
    easy: [15, 2],
    medium: [10, 1],
    hell: [5, 1]
  }.freeze

  def initialize
    @stats = DbUtils.get(DB)
    @player_name = ''
    @user_code = []
    show_welcome
    show_options
  end

  def run
    loop do
      response = user_enter
      case response
      when 'exit' then exit
      when 'rules' then show_rules
      when 'start' then start
      when 'stats' then show_stats(sort_stats)
      end
    end
  end

  private

  def start
    registration
    go
  end

  def go
    loop do
      show_msg(:AccompanyingMsg)
      answer = user_enter
      response = process_answer(answer)
      break unless response

      redo if response
    end
  end

  def process_answer(answer)
    case answer
    when 'hint' then request_of_hint
    when 'exit' then exit
    when /[1-6]+/ then check_code(answer)
    end
  end

  def request_of_hint
    show_msg(:HintsEnded) if @game.hints.zero?
    puts @game.give_hint unless @game.hints.zero?
  end

  def check_code(answer)
    exit if answer == 'exit'
    result = @game.result(answer)
    return false if won?(result)

    puts result
    # print "#{@user_code}, #{@game.secret_code}"
    return true unless @game.attempts.zero?

    lost
  end

  def sort_stats
    @stats.sort_by { |player| [player[:attempts_total], player[:attempts_used], player[:hints_used]] }
  end

  def generate_stats
    {
      name: @player_name,
      difficulty: @selected_difficulty,
      attempts_total: @attempts_total,
      attempts_used: @attempts_total - @game.attempts,
      hints_total: @hints_total,
      hints_used: @hints_total - @game.hints
    }
  end

  def registration
    _get_name
    _get_difficulty_level
  end

  def _get_name
    show_msg(:EnterName)
    @player_name = user_enter
    raise Exceptions::InvalidName if valid_name?(@player_name)
  rescue Exceptions::InvalidName => e
    puts e.message
    registration
  end

  def _get_difficulty_level
    show_msg(:Difficulty)
    @selected_difficulty = user_enter
    define_difficulty
    @game = Game.new(@attempts_total, @hints_total)
    @game.run
  end

  def define_difficulty
    case @selected_difficulty
    when 'easy' then @attempts_total, @hints_total = DIFFICULTY[:easy]
    when 'medium' then @attempts_total, @hints_total = DIFFICULTY[:medium]
    when 'hell' then @attempts_total, @hints_total = DIFFICULTY[:hell]
    end
  end

  def won?(result)
    if result == '++++'
      puts result
      show_msg(:Won)
      save_result?
      show_options
      return true
    end
    false
  end

  def save_result?
    show_msg(:SaveResult)
    response = user_enter
    save_result if response == 'yes'
  end

  def save_result
    @stats.push(generate_stats)
    DbUtils.add(DB, @stats)
  end

  def lost
    show_msg(:Lost)
    puts @game.secret_code.join
    show_options
    true
  end

  def exit
    show_msg(:Exit)
    abort
  end

  def user_enter
    gets.chomp!.downcase
  end
end
