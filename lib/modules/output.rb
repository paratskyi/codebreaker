module Output
  def show_welcome
    show_msg(:Welcome)
  end

  def show_options
    show_msg(:Options)
  end

  def show_rules
    show_msg(:Rules)
    show_options
  end

  def show_stats(sorted_stats)
    puts 'name difficulty attempts_total attempts_used hints_total hints_used'
    sorted_stats.each do |player|
      puts "#{player[:name]}       #{player[:difficulty]}       #{player[:attempts_total]}       #{player[:attempts_used]}       #{player[:hints_total]}       #{player[:hints_used]}"
    end
    show_options
  end

  def show_msg(type)
    puts I18n.t(type)
  end
end
