# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  if defined? ::ActiveRecord
    t.test_files = Dir['test/**/*_test.rb']
  else
    t.test_files = Dir['test/**/*_test.rb'] - Dir['test/**/*active_record*'] - Dir['test/**/*active_record*/*.rb']
  end
  t.warning = true
  t.verbose = true
end

task default: :test
