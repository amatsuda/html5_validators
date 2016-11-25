# frozen_string_literal: true
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# load Rails first
require 'rails'
require 'html5_validators'
# needs to load the app before loading rspec/rails => capybara
require 'fake_app'
require 'rspec/rails'
# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  if config.respond_to? :expect_with
    config.expect_with(:rspec) { |c| c.syntax = :should }
  end

  config.before :all do
    ActiveRecord::Migration.verbose = false
    CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'people'
  end
end
