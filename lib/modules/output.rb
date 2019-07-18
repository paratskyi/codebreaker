module Output
  include CommandLineReporter

  def show_welcome
    show_msg(:Welcome)
  end

  def show_options
    show_msg(:Options)
  end

  def show_rules
    show_msg(:Rules)
  end

  def show_stats(sorted_stats)
    table(border: true) do
      generate_table_titles
      generate_table_values(sorted_stats)
    end
  end

  def generate_table_titles
    row do
      column('Player name', width: 20)
      column('Difficulty', width: 10)
      column('Attempts total', width: 14)
      column('Attempts used', width: 13)
      column('Hints total', width: 11)
      column('Hints used', width: 11)
    end
  end

  def generate_table_values(sorted_stats)
    sorted_stats.each do |player|
      row do
        column(player[:name])
        column(player[:difficulty])
        column(player[:attempts_total])
        column(player[:attempts_used])
        column(player[:hints_total])
        column(player[:hints_used])
      end
    end
  end

  def show_msg(type)
    puts I18n.t(type)
  end
end
