module NagiosLogger
 def load_file_list(pref)
  Dir[File.join(pref, "*")].map{|n| File.basename(n) }
 end

 def load_files(pref, mask)
  data = []
  Dir[File.expand_path(File.join(pref, mask))].each do |fname|
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

 def make_events(sites)
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
  events
 end

 def parse_line(line)
  p "---parse", line
  data = {}
  line.force_encoding("KOI8-R").encode("UTF-8").scan(/^\[(\d+)\]\s+(.+)$/u) do |m|
   unless m[0]
    $stderr << m
    return nil
   end
   if m[1] !~ /^SERVICE ALERT/
    return nil
   end
   data.merge!(:stamp => Time.at(m[0].to_i))
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
end

