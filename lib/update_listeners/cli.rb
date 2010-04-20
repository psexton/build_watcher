require 'rubygems'
require 'optparse'
require 'serialport'
require 'codefumes'

module UpdateListeners
  class CLI
    DEFAULT_SERIAL_DEVICE = '/dev/tty.usbserial-A800ejOJ'
    DEVICE_BAUD_RATE = 9600
    ASCII_STX = 0x02
    ASCII_ETX = 0x03
    ASCII_US  = 0x1F

    def self.execute(stdout, arguments=[])
      @output_device = stdout
      parse_options!(arguments)

      device = BuildWatcher::ZigbeeDevice.new(@output_device)
      device.project_quantity.times do |project_index|
        project_info = device.project_info(project_index)
        project = CodeFumes::Project.find(project_info.public_key)
        device.broadcast_status(project.public_key, project.build_status)
      end
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
        opts.on("-d", "--device [RAW_DEVICE]",
                "Override the default serial device used (default: STDOUT)") {|device| @output_device = device}
        opts.parse!(arguments)
      end

    end

    def self.log(message, level = 'INFO')
      @stdout.puts "#{level}: #{message}"
    end
  end
end
