require 'rubygems'
require 'sinatra/base'
require File.expand_path(File.join(File.dirname(__FILE__), 'nagios_logger'))
include NagiosLogger
class NagiosWebbedLog < Sinatra::Base

  # This can display a nice status message.
  #
  get "/:year/:month/:day.csv" do
   get_params
   load_dates
   @events = load_events
   haml :index
  end

  get "/:year/:month/:day" do

  end

  get "/:year/:month" do
  
  end

  get "/:year" do

  end

  get "/" do
   if params[:day] && params[:day] != '0'
    redirect "/#{params[:year]}/#{params[:month]}/#{params[:day]}"
   elsif params[:month] && params[:month] != '0'
    redirect "/#{params[:year]}/#{params[:month]}"
   elsif params[:year] && params[:year] != '0'
    redirect "/#{params[:year]}"
   else
    load_dates
    @events = []
    haml :index
   end
  end

 def load_events
 end

 def get_params
  if params[:year] && (2000..2050).map(&:to_s).include?(params[:year])
   @year = params[:year]
  else
   @year = "0"
  end
  if params[:month] && (1..12).map(&:to_s).include?(params[:month])
   @month = params[:month]
  else
   @month = "0"
  end
  if params[:day] && (1..31).map(&:to_s).include?(params[:day])
   @day = params[:day]
  else
   @day = "0"
  end
 end

 def load_dates
  p "---log location", ENV["NAGIOS_LOG"]
  @names_list = load_file_list(ENV["NAGIOS_LOG"])
  p "---names", @names_list
  p "---split", @names_list.map{|n| n.split("-") }
  @years = @names_list.map{|n| n.split("-") }.map{|n| n[3] }.uniq
  p "---ye", @years
  @days = @names_list.map{|n| n.split("-") }.map{|n| n[2] }.uniq
  @months = @names_list.map{|n| n.split("-") }.map{|n| n[1] }.uniq
 end
 def load_arr
 end
end
