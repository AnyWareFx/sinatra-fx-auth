# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sinatra/version'


Gem::Specification.new do |gem|
  gem.name        = "sinatra-fx-auth"
  gem.version     = Sinatra::AuthFx::VERSION

  gem.authors     = ["Dave Jackson"]
  gem.email       = %w(dave.jackson@anywarefx.com)
  gem.description = %q{Sinatra::FxAuth - RESTful Authentication with Role-based Authorization for Sinatra}
  gem.summary     = %q{Sinatra::FxAuth - RESTful Authentication with Role-based Authorization for Sinatra}
  gem.homepage    = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)

  gem.add_dependency 'sinatra'
  gem.add_dependency 'fx-auth'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'cucumber'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'rack-test'
end