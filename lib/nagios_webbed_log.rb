require 'rubygems'
require 'sinatra/base'

class NagiosWebbedLog < Sinatra::Base

  # This can display a nice status message.
  #
  get "/:year/:monts/:day.csv" do

  end

  get "/:year/:monts/:day" do

  end

  get "/:year/:monts" do
  
  end

  get "/:year" do

  end

  get "/" do
    "Your skinny daemon is up and running."
  end

end
