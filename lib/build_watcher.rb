$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'build_watcher/zigbee_device'
require 'build_watcher/message'
require 'serialport'

module BuildWatcher
  VERSION = '0.0.1'

  class AppropriateMessageTypeNotFound < StandardError; end
end
