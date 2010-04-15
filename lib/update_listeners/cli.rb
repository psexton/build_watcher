require 'rubygems'
require 'optparse'
require 'serialport'

module UpdateListeners
  class CLI
    DEFAULT_SERIAL_DEVICE = '/dev/something'
    ASCII_STX = 0x02
    ASCII_ETX = 0x03
    ASCII_US  = 0x1F

    def self.execute(stdout, arguments=[])
      @stdout = stdout
      parse_options!(arguments)

      log "To update this executable, look in lib/update_listeners/cli.rb"
    end

    def self.parse_options!(arguments)
      OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')

          Usage: #{File.basename($0)} [options]

          Options are:
        BANNER
        opts.separator ""
        opts.on("-h", "--help",
                "Show this help message.") { @stdout.puts opts; exit }
        opts.on("-d", "--device",
                "Override the default serial device used (default: '#{@raw_device}')") {|arg| @raw_device = options[:device]}
        opts.parse!(arguments)
      end

    end

    def self.log(message, level = 'INFO')
      @stdout.puts "#{level}: #{message}"
    end
  end
end
