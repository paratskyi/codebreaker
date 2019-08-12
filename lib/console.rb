class Console
  include CodebreakerParatskiy
  include Validating
  include Output
  attr_accessor :user_code, :game

  def initialize
    @user_code = []
    run
  end

  def run
    show_welcome
    show_options
    loop do
      response = process_answer_menu(user_enter)
      exit if exit?(response)
      redo unless response
      break if response
    end
  end

  private

  def start
    registration
    loop do
      show_msg(:AccompanyingMsg)
      response = process_answer_game(user_enter)
      exit if exit?(response)
      redo unless response
      break if response
    end
  end

  def process_answer_menu(answer)
    exit if exit?(answer)
    case answer
    when 'rules' then show_rules
    when 'start' then start
    when 'stats' then show_stats(Statistic.sort_stats)
    else
      show_msg(:InvalidCommand)
      false
    end
  end

  def process_answer_game(answer)
    exit if exit?(answer)
    case answer
    when 'hint' then request_of_hint
    when /^[1-6]{4}$/ then check_code(answer)
    else
      show_msg(:InvalidCommand)
      false
    end
  end

  def request_of_hint
    @game.hints.zero? ? show_msg(:HintsEnded) : (puts @game.give_hint)
  end

  def check_code(answer)
    exit if exit?(answer)
    result = @game.result(answer)
    puts result
    return won if @game.won?(result)
    return lost if @game.lost?
  end

  def registration
    @game = Game.new(_get_name, _get_difficulty_level)
    @game.run
  end

  def _get_name
    show_msg(:EnterName)
    answer = user_enter
    exit if exit?(answer)
    raise Exceptions::InvalidName unless valid_name?(answer)

    answer
  rescue Exceptions::InvalidName => e
    puts e.message
    registration
  end

  def _get_difficulty_level
    show_msg(:Difficulty)
    answer = user_enter
    exit if exit?(answer)
    answer
  end

  def won
    show_msg(:Won)
    @game.save_result if save_result?
    show_options
    true
  end

  def save_result?
    show_msg(:SaveResult)
    answer = user_enter
    answer == 'yes'
  end

  def lost
    show_msg(:Loss)
    puts @game.secret_code.join
    show_options
    true
  end

  def exit
    show_msg(:Exit)
    exit
  end

  def user_enter
    gets.chomp!.downcase
  end

  def exit?(answer)
    answer == 'exit'
  end
end
