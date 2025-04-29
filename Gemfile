# frozen_string_literal: true
source 'https://rubygems.org'

# Specify your gem's dependencies in html5_validators.gemspec
gemspec

if ENV['RAILS_VERSION'] == 'edge'
  gem 'railties', git: 'https://github.com/rails/rails.git'
  gem 'activerecord', git: 'https://github.com/rails/rails.git'
  gem 'sqlite3'
elsif ENV['RAILS_VERSION'] && !ENV['RAILS_VERSION'].empty?
  gem 'railties', "~> #{ENV['RAILS_VERSION']}.0"
  gem 'activerecord', "~> #{ENV['RAILS_VERSION']}.0"
  if ENV['RAILS_VERSION'] <= '5.0'
    gem 'sqlite3', '< 1.4'
  elsif (ENV['RAILS_VERSION'] <= '8') || (RUBY_VERSION < '3')
    gem 'sqlite3', '< 2'
  end

  if ENV['RAILS_VERSION'] < '4'
    gem 'capybara', '~> 2.0.0'
    gem 'test-unit-rails', '1.0.2'
  end

  gem 'webdrivers' if (ENV['RAILS_VERSION'] && ENV['RAILS_VERSION'] >= '6') && (RUBY_VERSION < '3')

elsif ENV['ACTIVEMODEL_VERSION']
  gem 'railties', "~> #{ENV['ACTIVEMODEL_VERSION']}.0"
  gem 'activemodel', "~> #{ENV['ACTIVEMODEL_VERSION']}.0"
else
  gem 'railties'
  gem 'activerecord'
  gem 'sqlite3'
end

if RUBY_VERSION < '2.7'
  gem 'puma', '< 6'
else
  gem 'puma'
end

gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gem 'loofah', RUBY_VERSION < '2.5' ? '< 2.21.0' : '>= 0'
gem 'selenium-webdriver'
gem 'net-smtp' if RUBY_VERSION >= '3.1'
