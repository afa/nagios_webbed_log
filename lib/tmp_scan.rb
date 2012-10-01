# encoding: utf-8
require "ostruct"
lines = []
$stdin.each do |line|
 lines << parse_line(line)
end
sites = {}
lines.compact.each do |hsh|
 place_host(hsh, sites)
end
sort_sites(sites)
events = []
event = []
sites.each do |k, v|
 v.each do |key, val|
  val.each do | it |
   event << it
   if it[:level] == "OK"
    events << event.dup
    event.clear
   end
  end
 end
end
levs = %w(OK WARNING CRITICAL UNKNOWN)
events.each do |its|
 lvl = its.map{|it| levs.index(it[:level]) || 3 }.max
 ll = its.detect{|it| not levs.include?(it[:level]) }
 len = its.last[:stamp] - its.first[:stamp]
 $stderr << ll[:level] if ll
 puts "#{its.first[:host]}\t#{its.first[:service]}\t#{its.first[:stamp].to_i}\t#{its.first[:stamp].strftime("%Y-%m-%d %H:%M:%S")}\t#{levs[lvl]}\t#{len}\t#{its.first[:message]}"
end

def load_files(pref, mask)
 data = []
 Dir[File.join(pref, mask)].each do |fname|
  data += load_file(fname, data)
 end
 data
end

def load_file(fname, data)
 File.open(fname, "r") do |f|
  f.readlines.each do |line|
   data << line
  end
 end
 data
end

def parse_line(line)
 data = {}
 line.force_encoding("KOI8-R").encode("UTF-8").scan(/^\[(\d+)\]\s+(.+)$/u) do |m|
  unless m[0]
   $stderr << m
   return nil
  end
  if m[1] !~ /^SERVICE ALERT/
   return nil
  end
  data.merge(:stamp => Time.at(m[0].to_i))
  m[1].scan(/SERVICE ALERT:\s+(.+?);(.+?);(.+?);(.+?);(.+?);(.+)$/) do |n|
   data[:host] = n[0]
   data[:service] = n[1]
   data[:level] = n[2]
   data[:type] = n[3]
   data[:count] = n[4]
   data[:message] = n[5]
  end
 end
 data
end

def place_host(hsh, sites)
 unless sites.has_key?(hsh[:host])
  sites[hsh[:host]] = {}
 end
 unless sites[hsh[:host]].has_key?(hsh[:service])
  sites[hsh[:host]][hsh[:service]] = []
 end
 sites[hsh[:host]][hsh[:service]] << hsh
end

def sort_sites(sites)
 sites.each do |k, v|
  v.each do |key, val|
   val.sort!{|a, b| a[:stamp] <=> b[:stamp] }
  end
 end
end
