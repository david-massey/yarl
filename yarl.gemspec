# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yarl/version'

Gem::Specification.new do |spec|
  spec.name          = 'yarl'
  spec.version       = YARL::VERSION
  spec.authors       = ['David Massey']
  spec.email         = ['ominousskitter@protonmail.com']
  spec.summary       = %q{Logger extension that provides colors and clean, default formatting.}
  spec.description   = %q{Yet Another Ruby Logger (YARL) extends ruby/logger to provide header colors and a severity level below DEBUG. The default formatting has been changed to provide a cleaner (subjective) look.}
  spec.homepage      = "https://github.com/david-massey/yarl"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency "logger", "1.3.0"

  spec.add_development_dependency "bundler"
end
