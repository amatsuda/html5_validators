# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'html5_validators/version'

Gem::Specification.new do |s|
  s.name        = 'html5_validators'
  s.version     = Html5Validators::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Akira Matsuda']
  s.email       = ['ronnie@dio.jp']
  s.homepage    = 'https://github.com/amatsuda/html5_validators'
  s.summary     = 'Automatic client side validation using HTML5 Form Validation'
  s.description = 'A gem/plugin for Rails 3 that enables client-side validation using ActiveModel + HTML5'

  s.rubyforge_project = 'html5_validators'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
end
