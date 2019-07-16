require 'simplecov'
SimpleCov.start

require 'bundler/setup'

require_relative '../lib/config/constants'
require_relative '../lib/exceptions/exceptions'
require_relative '../lib/modules/validating'
require_relative '../lib/codebreaker_paratskiy'
require_relative '../lib/modules/output'
require_relative '../lib/console'
require_relative '../lib/utils/db_utils'
