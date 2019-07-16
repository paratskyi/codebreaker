class Console
  include CodebreakerParatskiy
  include Validating
  include Output
  attr_accessor :player_name, :user_code

  def initialize
    @player_name = ''
    @user_code = []
    show_welcome
    show_options
  end

  def run
    loop do
      answer = user_enter
      response = process_answer_menu(answer)
      break unless response

      redo if response
    end
  end

  private

  def start
    registration
    loop do
      show_msg(:AccompanyingMsg)
      answer = user_enter
      response = process_answer_game(answer)
      break unless response

      redo if response
    end
  end

  def process_answer_menu(answer)
    case answer
    when 'exit' then exit
    when 'rules' then show_rules
    when 'start' then start
    when 'stats' then show_stats(sort_stats)
    else
      show_msg(:InvalidCommand)
      false
    end
  end

  def process_answer_game(answer)
    case answer
    when 'hint' then request_of_hint
    when 'exit' then exit
    when /[1-6]+/ then check_code(answer)
    else
      show_msg(:InvalidCommand)
      true
    end
  end

  def request_of_hint
    show_msg(:HintsEnded) if @game.hints.zero?
    puts @game.give_hint unless @game.hints.zero?
    true
  end

  def check_code(answer)
    exit if answer == 'exit'
    result = @game.result(answer)
    return false if won?(result)

    return true unless @game.attempts.zero?

    lost
    puts result
  end

  def sort_stats
    @stats.sort_by { |player| [player[:attempts_total], player[:attempts_used], player[:hints_used]] }
  end

  def registration
    _get_name
    _get_difficulty_level
  end

  def _get_name
    show_msg(:EnterName)
    @player_name = user_enter
    raise Exceptions::InvalidName unless valid_name?(@player_name)
  rescue Exceptions::InvalidName => e
    puts e.message
    registration
  end

  def _get_difficulty_level
    show_msg(:Difficulty)
    @selected_difficulty = user_enter
    @game = Game.new(@player_name, @selected_difficulty)
    @game.run
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
    @game.save_result if response == 'yes'
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
