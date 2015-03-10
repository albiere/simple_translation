# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_translation/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_translation"
  spec.version       = SimpleTranslation::VERSION
  spec.authors       = ["Angelo Albiero Neto"]
  spec.email         = ["angeloalbiero@gmail.com"]

  spec.summary       = %q{Simple translate abstraction library}
  spec.description   = %q{Get translations from various languages translation services.}
  spec.homepage      = "http://github.com/albiere/simple_translation"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9.1"
  spec.add_dependency "nokogiri", "~> 1.6.6.2"
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.0.11"
  spec.add_development_dependency "mocha", "~> 1.1.0"
end
