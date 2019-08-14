class Console
  include CodebreakerParatskiy
  include Validating
  include Output
  attr_accessor :user_code, :game

  def initialize
    @user_code = []
  end

  def run
    show_welcome
    main_menu
  end

  def main_menu
    show_main_menu
    answer = user_enter
    return process_answer_menu(answer) if MAIN_MENU_COMMANDS.include?(answer)

    show_msg(:InvalidCommand)
    main_menu
  end

  def start
    registration
    loop do
      return lost if @game.lost?

      show_msg(:AccompanyingMsg)
      answer = user_enter
      case answer
      when 'hint', /^[1-6]{4}$/
        return won if @game.won?(check_code(answer))
      else
        show_msg(:InvalidCommand)
        redo
      end
    end
  end

  def process_answer_menu(answer)
    send(MAIN_MENU_COMMANDS[answer])
    main_menu if answer != 'start'
  end

  def request_of_hint
    @game.hints.zero? ? show_msg(:HintsEnded) : (puts @game.give_hint)
  end

  def check_code(answer)
    result = @game.result(answer)
    puts result
    result
  end

  def registration
    @game = Game.new(_get_name, _get_difficulty_level)
    @game.run
  end

  def _get_name
    show_msg(:EnterName)
    answer = user_enter

    raise Exceptions::InvalidName unless valid_name?(answer)

    answer
  rescue Exceptions::InvalidName => e
    puts e.message
    registration
  end

  def _get_difficulty_level
    show_msg(:Difficulty)
    answer = user_enter
    return DIFFICULTIES[answer.to_sym] if DIFFICULTIES.include?(answer.to_sym)

    show_msg(:InvalidCommand)
    _get_difficulty_level
  end

  def save_result?
    show_msg(:SaveResult)
    answer = user_enter
    answer == 'yes'
  end

  def won
    show_msg(:Won)
    @game.save_result if save_result?
    main_menu
  end

  def lost
    show_msg(:Loss)
    puts @game.secret_code.join
    main_menu
  end

  def user_enter
    enter = gets.chomp!.downcase
    exit if exit?(enter)
    enter
  end

  def exit?(answer)
    answer == 'exit'
  end
end
