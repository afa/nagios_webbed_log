require 'rubygems'
require 'sinatra/base'
require File.expand_path(File.join(File.dirname(__FILE__), 'nagios_logger'))
include NagiosLogger
class NagiosWebbedLog < Sinatra::Base

  # This can display a nice status message.
  #
  get "/:year/:month/:day.csv" do
  end

  get "/:year/:month/:day" do
   get_params
   load_dates
   @events = load_events
   haml :index
  end

  get "/:year/:month" do
   get_params
   load_dates
   @events = load_events
   haml :index
  end

  get "/:year" do
   get_params
   load_dates
   @events = load_events
   haml :index
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
  lines = load_files(ENV["NAGIOS_LOG"],"nagios-#{@month.to_i == 0 ? '*' : @month}-#{@day.to_i == 0 ? '*' : @day}-#{@year.to_i == 0 ? '*' : @year}-*.log")
  sites = {}
  lines.compact.map{|l| parse_line(l) }.compact.each do |hsh|
   place_host(hsh, sites)
  end
  sort_sites(sites)
  events = make_events(sites)
  events
 end

 def get_params
  if params[:year] && (2000..2050).map(&:to_s).include?(params[:year])
   @year = params[:year]
  else
   @year = "0"
  end
  if params[:month] && (1..12).map(&:to_s).map{|s| s.rjust(2, "0") }.include?(params[:month])
   @month = params[:month]
  else
   @month = "0"
  end
  if params[:day] && (1..31).map(&:to_s).map{|s| s.rjust(2, "0") }.include?(params[:day])
   @day = params[:day]
  else
   @day = "0"
  end
 end

 def load_dates
  @names_list = load_file_list(ENV["NAGIOS_LOG"])
  @years = @names_list.map{|n| n.split("-") }.map{|n| n[3] }.uniq
  @days = @names_list.map{|n| n.split("-") }.map{|n| n[2] }.uniq
  @months = @names_list.map{|n| n.split("-") }.map{|n| n[1] }.uniq
 end
end
