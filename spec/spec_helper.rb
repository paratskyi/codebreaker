require 'simplecov'
SimpleCov.start

require 'bundler/setup'

require_relative '../lib/exceptions/exceptions.rb'
require_relative '../lib/modules/validating.rb'
require_relative '../lib/codebreaker_paratskiy.rb'
require_relative '../lib/console.rb'
require_relative '../lib/utils/db.rb'
