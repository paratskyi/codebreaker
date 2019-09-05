DB = 'stats.yml'.freeze

DIFFICULTIES = {
  easy: { attempts: 15, hints: 2 },
  medium: { attempts: 10, hints: 1 },
  hell: { attempts: 5, hints: 1 },
  default: { attempts: 0, hints: 0 }
}.freeze

DEFAULT_NAME = 'default'.freeze

MAIN_MENU_COMMANDS = {
  'start' => :start,
  'rules' => :show_rules,
  'stats' => :show_stats,
  'exit' => :exit
}.freeze

WINNING_RESULT = '++++'.freeze

START_COMMAND = 'start'.freeze

CONFIRM_COMMAND = 'yes'.freeze

EXIT_COMMAND = 'exit'.freeze
