#coding: UTF-8
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'nagios_webbed_log'))
NagiosWebbedLog.run! :port => 3600
