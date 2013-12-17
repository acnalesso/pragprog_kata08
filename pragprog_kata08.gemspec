# coding: utf-8
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'pragprog_kata08/version'

Gem::Specification.new do |spec|
  spec.name          = "pragprog_kata08"
  spec.version       = PragprogKata08::VERSION.dup
  spec.authors       = ["Antonio C Nalesso"]
  spec.email         = ["acnalesso@yahoo.co.uk"]
  spec.summary       = %q{Easy way to retrieve words which are composed of two concatenated words.}
  spec.description   = %q{ Using a Radix Tree or PRATRICIA , It processes a dictionary and looks for all six letter words which are composed of two concatenated smaller words}
  spec.homepage      = "https://github.com/acnalesso/pragprog_kata08"
  spec.license       = "GNU/GPL3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
end
