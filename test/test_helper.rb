# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# load Rails first
require 'rails'
require 'bundler/setup'
Bundler.require
require 'capybara'
require 'selenium/webdriver'

# needs to load the app before loading rspec/rails => capybara
require 'fake_app'

require 'active_support/test_case'
require 'test/unit/active_support'
require 'test/unit/capybara'
require 'capybara/rails'
require 'capybara/dsl'
ActionDispatch::IntegrationTest.send :include, Capybara::DSL

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

begin
  require "action_dispatch/system_test_case"
rescue LoadError
  Capybara.register_driver :chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu])
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
  Capybara.javascript_driver = :chrome
else
  ActionDispatch::SystemTestCase.driven_by(:selenium, using: :headless_chrome)
end
