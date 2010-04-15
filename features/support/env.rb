require File.dirname(__FILE__) + "/../../lib/build_watcher"
require File.dirname(__FILE__) + "/../../lib/build_watcher/fake_arduino"

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'

require 'ruby-debug'


Before do
  @tmp_root = File.dirname(__FILE__) + "/../../tmp"
  @home_path = File.expand_path(File.join(@tmp_root, "home"))
  @lib_path  = File.expand_path(File.dirname(__FILE__) + "/../../lib")
  FileUtils.rm_rf   @tmp_root
  FileUtils.mkdir_p @home_path
  ENV['HOME'] = @home_path
end
