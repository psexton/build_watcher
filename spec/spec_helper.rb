begin
  require 'spec'
  require 'ruby-debug'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'build_watcher'
require 'build_watcher/fake_serial_port'
include BuildWatcher
