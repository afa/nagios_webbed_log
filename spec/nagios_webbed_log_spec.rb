require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "NagiosWebbedLog" do
 it "should get /" do
  get "/"
  response.should be_success
 end
end
