class Console
  include CodebreakerParatskiy

  attr_accessor :player_name

  DB = 'stats.yml'.freeze

  def initialize
    @stats = DbUtils.get(DB)
    @player_name = ''
    show_welcome
    show_options
  end

  def start
    @game = Game.new
    @game.run
    registration

    loop do
      if @game.attempts.zero?
        puts 'Sorry, you are lost'
        print @game.secret_code.join
        show_options
        break
      end

      puts 'Please, enter your code or take hint'
      user_enter = gets.chomp!.downcase

      case user_enter
      when 'hint' then hint
      when 'exit'
        puts 'Are you shure?'
        puts 'Yes or No'
        is_exit = gets.chomp!.downcase
        self.exit if is_exit == 'yes'
        redo
      when /[1-6]+/
        user_code = user_enter.each_char.map(&:to_i)
        result = @game.result(user_code)
        print "#{user_code}, #{@game.secret_code}"
        if result == '++++'
          puts result
          puts 'Congratulations, you are win'
          save_result?
          show_options
          break
        end
        puts result
        redo unless @game.attempts.zero?
      end
    end
  end

  def hint
    puts 'You used all the hints' if @game.hints.zero?
    puts @game.give_hint unless @game.hints.zero?
  end

  def registration
    puts 'Please, enter your name'
    @player_name = gets.chomp!.downcase

    puts @game.secret_code
    puts 'Please, enter difficulty level'
    puts '1. Easy - 15 attempts. 2 hints'
    puts '2. Medium - 10 attempts. 1 hint'
    puts '3. Hell - 5 attempts. 1 hint'

    @difficulty_level = gets.chomp!.downcase

    case @difficulty_level
    when 'easy'
      @game.attempts = @attempts_total = 15
      @game.hints = @hints_total = 2
    when 'medium'
      @game.attempts = @attempts_total = 10
      @game.hints = @hints_total = 1
    when 'hell'
      @game.attempts = @attempts_total = 5
      @game.hints = @hints_total = 1
    end
  end

  def run
    loop do
      user_enter = gets.chomp!.downcase
      puts user_enter
      case user_enter
      when 'exit'
        exit
        break
      when 'rules' then rules
      when 'start' then start
      when 'stats'
        stats
        redo
      end
    end
  end

  def show_welcome
    puts 'Welcome to codebreaker game'
  end

  def show_options
    puts 'Choose from propose options what do you want to do'
    puts '1. Start'
    puts '2. Rules'
    puts '3. Stats'
    puts '4. Exit'
  end

  def rules
    puts 'Codebreaker is a logic game in which a code-breaker tries to break a secret code created by a code-maker. The codemaker, which will be played by the application we’re going to write, creates a secret code of four numbers between 1 and 6.'
    puts 'The codebreaker gets some number of chances to break the code (depends on chosen difficulty). In each turn, the codebreaker makes a guess of 4 numbers. The codemaker then marks the guess with up to 4 signs - + or - or empty spaces.'
    puts 'A + indicates an exact match: one of the numbers in the guess is the same as one of the numbers in the secret code and in the same position. For example:'
    puts 'Secret number - 1234'
    puts 'Input number - 6264'
    puts 'Number of pluses - 2 (second and fourth position)'
    puts 'A - indicates a number match: one of the numbers in the guess is the same as one of the numbers in the secret code but in a different position. For example:'
    puts 'Secret number - 1234'
    puts 'Input number - 6462'
    puts 'Number of minuses - 2 (second and fourth position)'
    puts 'An empty space indicates that there is not a current digit in a secret number.'
    puts 'If codebreaker inputs the exact number as a secret number - codebreaker wins the game. If all attempts are spent - codebreaker loses.'
    puts 'Codebreaker also has some number of hints(depends on chosen difficulty). If a user takes a hint - he receives back a separate digit of the secret code.'
    show_options
  end

  def save_result?
    puts 'Do you want to save the result?'
    puts 'Yes or No'
    answer = gets.chomp!.downcase
    save_result if answer == 'yes'
  end

  def create_stats
    {
      name: @player_name,
      difficulty: @difficulty_level,
      attempts_total: @game.attempts,
      attempts_used: @attempts_total - @game.attempts,
      hints_total: @game.hints,
      hints_used: @hints_total - @game.hints
    }
  end

  def save_result
    @stats.push(create_stats)
    DbUtils.add(DB, @stats)
  end

  def stats
    sorted_stats = @stats.sort_by { |player| player[:attempts_total] }.sort_by { |player| player[:attempts_used] }.sort_by { |player| -player[:hints_used] }
    puts 'name difficulty attempts_total attempts_used hints_total hints_used'
    sorted_stats.each do |player|
      puts "#{player[:name]}       #{player[:difficulty]}       #{player[:attempts_total]}       #{player[:attempts_used]}       #{player[:hints_total]}       #{player[:hints_used]}"
    end
  end

  def exit
    'Goodbye'
  end
end
