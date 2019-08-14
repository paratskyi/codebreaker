DB = 'stats.yml'.freeze

DIFFICULTIES = {
  easy: { attempts: 15, hints: 2 },
  medium: { attempts: 10, hints: 1 },
  hell: { attempts: 5, hints: 1 }
}.freeze

MAIN_MENU_COMMANDS = {
  'start' => :start,
  'rules' => :show_rules,
  'stats' => :show_stats,
  'exit' => :exit
}.freeze
