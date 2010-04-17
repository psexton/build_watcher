require File.dirname(__FILE__) + "/../../lib/build_watcher"
require File.dirname(__FILE__) + "/../../lib/build_watcher/fake_serial_port"
require File.dirname(__FILE__) + "/../../lib/update_listeners/cli"

include BuildWatcher

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'
require 'spec/mocks'

require 'ruby-debug'
require 'codefumes_harvester'


Before do
  @tmp_root = File.dirname(__FILE__) + "/../../tmp"
  @home_path = File.expand_path(File.join(@tmp_root, "home"))
  @lib_path  = File.expand_path(File.dirname(__FILE__) + "/../../lib")
  FileUtils.rm_rf   @tmp_root
  FileUtils.mkdir_p @home_path
  ENV['HOME'] = @home_path
  CodeFumes::Project.mode(:test)
  CodeFumes::Commit.mode(:test)
  CodeFumes::Payload.mode(:test)
  CodeFumes::Build.mode(:test)
end
