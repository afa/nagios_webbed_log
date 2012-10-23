require 'rubygems'
require 'sinatra/base'
require 'csv'
require File.expand_path(File.join(File.dirname(__FILE__), 'nagios_logger'))
include NagiosLogger
class NagiosWebbedLog < Sinatra::Base

  # This can display a nice status message.
  #
  get "/:year/:month/:day.csv" do
   get_params
   load_dates
   @events = load_events
   response.headers['content_type'] = "application/csv"
   attachment("failures-#{@year}-#{@month}-#{@day}.csv")
   response.write to_csv(@events)
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
 def to_csv(data)
  levs = %w(OK WARNING CRITICAL UNKNOWN)
  out = CSV.generate( {:col_sep => ";"}) do |csv|
   #csv << hdr
   data.each do |evt|
    lvl = evt.map{|it| levs.index(it[:level]) || 3 }.max
    ll = evt.detect{|it| not levs.include?(it[:level]) }
    csv << [evt.first[:stamp].strftime("%Y-%m-%d"), evt.first[:stamp].strftime("%H:%M:%S"), (evt.last[:stamp] - evt.first[:stamp]).to_i, evt.first[:service], NagiosLogger::LEVEL_LUT[levs[lvl]]]
   end
  end
  out.force_encoding('UTF-8').encode('Windows-1251')
 end
end
