require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../lib/nagios_webbed_log')

describe "NagiosWebbedLog" do
 it "should get /" do
  get "/"
  last_response.should be_ok
 end
end



=begin
require File.join(File.dirname(__FILE__), '..', 'blog.rb')

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

describe "get /" do
  it "should display the homepage" do
    get "/"
    last_response.should be_ok
  end
end
=end
