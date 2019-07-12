class Console
  include CodebreakerParatskiy
  include Validating
  attr_accessor :player_name

  DB = 'stats.yml'.freeze

  def initialize
    @stats = DbUtils.get(DB)
    @player_name = ''
    show_welcome
    show_options
  end

  def show_msg(type)
    puts I18n.t(type)
  end

  def start
    @game = Game.new
    @game.run
    registration

    loop do
      if @game.attempts.zero?
        show_msg(:Lost)
        puts @game.secret_code.join
        show_options
        break
      end

      show_msg(:Escort)
      response = user_enter

      case response
      when 'hint' then hint
      when 'exit'
        puts I18n.t(:Shure?)
        is_exit = user_enter
        self.exit if is_exit == 'yes'
        redo
      when /[1-6]+/
        user_code = response.each_char.map(&:to_i)
        result = @game.result(user_code)
        print "#{user_code}, #{@game.secret_code}"
        if result == '++++'
          puts result
          show_msg(:Won)
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
    show_msg(:HintsEnded) if @game.hints.zero?
    puts @game.give_hint unless @game.hints.zero?
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
    puts @game.secret_code ######################## Убрать #######################################

    show_msg(:Difficulty)

    @difficulty_level = user_enter

    case @difficulty_level
    when 'easy'
      @game.attempts = 15
      @attempts_total = 15
      @game.hints = 2
      @hints_total = 2
    when 'medium'
      @game.attempts = 10
      @attempts_total = 10
      @game.hints = 1
      @hints_total = 1
    when 'hell'
      @game.attempts = 5
      @attempts_total = 5
      @game.hints = 1
      @hints_total = 1
    end
  end

  def registration
    _get_name
    _get_difficulty_level
  end

  def run
    loop do
      response = user_enter
      puts response
      case response
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
    show_msg(:Welcome)
  end

  def show_options
    show_msg(:Options)
  end

  def rules
    show_msg(:Rules)
    show_options
  end

  def save_result?
    show_msg(:SaveResult)
    response = user_enter
    save_result if response == 'yes'
  end

  def create_stats
    {
      name: @player_name,
      difficulty: @difficulty_level,
      attempts_total: @attempts_total,
      attempts_used: @attempts_total - @game.attempts,
      hints_total: @hints_total,
      hints_used: @hints_total - @game.hints
    }
  end

  def save_result
    @stats.push(create_stats)
    DbUtils.add(DB, @stats)
  end

  def stats
    sorted_stats = @stats.sort_by { |player| player[:attempts_total] }.sort_by { |player| player[:attempts_used] }.sort_by { |player| player[:hints_used] }
    puts 'name difficulty attempts_total attempts_used hints_total hints_used'
    sorted_stats.each do |player|
      puts "#{player[:name]}       #{player[:difficulty]}       #{player[:attempts_total]}       #{player[:attempts_used]}       #{player[:hints_total]}       #{player[:hints_used]}"
    end
  end

  def user_enter
    gets.chomp!.downcase
  end

  def exit
    show_msg(:Exit)
  end
end
