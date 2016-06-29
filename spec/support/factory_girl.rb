RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) { FactoryGirl.find_definitions }
end
