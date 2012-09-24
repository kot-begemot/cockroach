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
  gem.name = "cockroach"
  gem.homepage = "http://google.it"
  gem.license = "MIT"
  gem.summary = %Q{This gem allows one to fake all the date for the Artirix project}
  gem.description = %Q{In order to simplify the life of the Artirix developers, this gem was build.
  It allows to generate the data, and fill teh database with fake records.}
  gem.email = "max.zab@artirix.com"
  gem.authors = ["E-Max"]
  # dependencies defined in Gemfile
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

require 'yard'
YARD::Rake::YardocTask.new