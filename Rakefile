# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "nagios_webbed_log"
  gem.homepage = "http://github.com/afa/nagios_webbed_log"
  gem.license = "MIT"
  gem.summary = %Q{simple nagios log publisher}
  gem.description = %Q{simple nagios log publisher}
  gem.email = "afa.alone@gmail.com"
  gem.authors = ["afa"]
  gem.executables = ['nagios_webbed_log']
  gem.add_dependency "sinatra"
  gem.add_dependency "haml"
  gem.add_dependency "thin"
  gem.add_development_dependency "rspec", ">= 2.8.0"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "rdoc", "~> 3.12"
  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "jeweler", "~> 1.8.4"
  gem.add_development_dependency "simplecov", ">= 0"

  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "nagios_webbed_log #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
