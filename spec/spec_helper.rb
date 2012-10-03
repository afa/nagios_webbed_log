$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib')))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
require 'rspec'
require 'rack/test'
require 'nagios_webbed_log'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def app
  Sinatra::Application
end

RSpec.configure do |config|
 config.include Rack::Test::Methods
end
