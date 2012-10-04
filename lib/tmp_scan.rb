# encoding: utf-8
require "ostruct"
include NagiosLogger
lines = []
$stdin.each do |line|
 lines << parse_line(line)
end
sites = {}
lines.compact.each do |hsh|
 place_host(hsh, sites)
end
sort_sites(sites)
events = make_events(sites)
levs = %w(OK WARNING CRITICAL UNKNOWN)
events.each do |its|
 lvl = its.map{|it| levs.index(it[:level]) || 3 }.max
 ll = its.detect{|it| not levs.include?(it[:level]) }
 len = its.last[:stamp] - its.first[:stamp]
 $stderr << ll[:level] if ll
 puts "#{its.first[:host]}\t#{its.first[:service]}\t#{its.first[:stamp].to_i}\t#{its.first[:stamp].strftime("%Y-%m-%d %H:%M:%S")}\t#{levs[lvl]}\t#{len}\t#{its.first[:message]}"
end

