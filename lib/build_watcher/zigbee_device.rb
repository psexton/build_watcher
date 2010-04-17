module BuildWatcher
  class ZigbeeDevice
    ASCII_STX = "\002"
    ASCII_ETX = "\003"
    ASCII_SEP = "\037"

    def initialize(device)
      @device = device
    end

    def project_quantity
      serial_device do
        request_project_count
        read_project_count
      end
    end

    private
      def request_project_count
        @connection.puts "#{ASCII_STX}Q#{ASCII_ETX}"
      end

      def read_project_count
        quantity_message = first_quantity_message_on_buffer
        if quantity_message.nil?
          raise AppropriateMessageTypeNotFound, "No 'quantity' message type found on serial buffer."
        end

        quantity_message.split(/#{ASCII_SEP}/).last.to_i
      end

      def first_quantity_message_on_buffer
        individual_messages.find {|m| m[0].chr == "N"}
      end

      def individual_messages
        @connection.read.scan(/#{ASCII_STX}(.*?)#{ASCII_ETX}/).flatten
      end

      def serial_device(&block)
        @connection = SerialPort.new(@device, 9600)
        @connection.read_timeout = -1
        yield
      ensure
        @connection.close
      end
  end
end
