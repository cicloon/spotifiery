# -*- encoding: utf-8 -*-
require File.expand_path('../lib/spotifiery/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["cicloon"]
  gem.email         = ["aleon.prof@gmail.com"]
  gem.description   = %q{Spotify Web API wrapper}
  gem.summary       = %q{This gem provides an API wrapper for the spotify Web search API}
  gem.homepage      = "https://github.com/cicloon/spotifiery"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "spotifiery"
  gem.require_paths = ["lib"]
  gem.version       = Spotifiery::VERSION

  gem.add_dependency "httparty", ">= 0.9.0"  
  gem.add_dependency %q<activesupport>, ">= 3.0"

  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "webmock", "< 1.9.0"
  gem.add_development_dependency "vcr", "~> 2.3.0"


end
