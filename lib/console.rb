require_relative 'codebreaker_paratskiy'
class Console
  include CodebreakerParatskiy
  include Validating
  include Output
  attr_accessor :user_code

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

  private

  def start
    registration
    game_scenario
  end

  def game_scenario
    loop do
      return lost if game.lost?

      show_msg(:AccompanyingMsg)
      process_answer_game(user_enter)
    end
  end

  def process_answer_game(answer)
    case answer
    when /^[1-6]{4}$/
      return won if game.won?(check_code(answer))
    when 'hint' then request_of_hint
    else show_msg(:InvalidCommand)
    end
  end

  def process_answer_menu(answer)
    send(MAIN_MENU_COMMANDS[answer])
    main_menu if answer != START_COMMAND
  end

  def request_of_hint
    game.hints.zero? ? show_msg(:HintsEnded) : (puts game.use_hint)
  end

  def check_code(answer)
    result = game.result(answer)
    puts result
    result
  end

  def registration
    CodebreakerParatskiy.run_game(_get_name, _get_difficulty_level)
  end

  def _get_name
    show_msg(:EnterName)
    answer = user_enter

    return answer if valid_name?(answer)

    show_msg(:InvalidCommand)
    _get_name
  end

  def _get_difficulty_level
    show_msg(:EnterDifficulty)
    answer = user_enter
    return answer if DIFFICULTIES.include?(answer.to_sym)

    show_msg(:InvalidCommand)
    _get_difficulty_level
  end

  def save_result?
    show_msg(:SaveResult)
    user_enter == CONFIRM_COMMAND
  end

  def won
    show_msg(:Won)
    game.save_result if save_result?
    main_menu
  end

  def lost
    show_msg(:Loss)
    puts game.secret_code.join
    main_menu
  end

  def user_enter
    enter = gets.chomp.downcase
    if exit?(enter)
      show_msg(:Exit)
      exit
    end
    enter
  end

  def exit?(answer)
    answer == EXIT_COMMAND
  end

  def game
    CurrentGame.game
  end
end
