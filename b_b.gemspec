lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "b_b/version"

Gem::Specification.new do |spec|
  spec.name          = "b_b"
  spec.version       = BB::VERSION
  spec.authors       = ["Yoshiyuki Hirano"]
  spec.email         = ["yhirano@me.com"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.summary       = "(b_b) is SQL Query Builder for Google BigQuery"
  spec.description   = "(b_b) is SQL Query Builder for Google BigQuery"
  spec.homepage      = "https://github.com/yhirano55/b_b"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",       "~> 1.11"
  spec.add_development_dependency "rake",          "~> 10.0"
  spec.add_development_dependency "rspec",         "~> 3.0"
  spec.add_development_dependency "activesupport", "~> 4.2.0"
  spec.add_development_dependency "factory_girl",  "~> 4.0"
  spec.add_development_dependency "faker",         "~> 1.6.0"
  spec.add_development_dependency "pry",           "~> 0.10.0"
  spec.add_development_dependency "rubocop",       "~> 0.40.0"
  spec.add_development_dependency "simplecov",     "~> 0.11.0"
  spec.add_development_dependency "coveralls",     "~> 0.8.0"
end
