require "simplecov"
require "coveralls"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
]

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end

Bundler.require(:default, :test)
require "b_b"
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each(&method(:require))

RSpec.configure do |config|
  config.order = :random
end
