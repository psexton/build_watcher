module BuildWatcher
  class ZigbeeDevice
    MAX_SERIAL_DEVICE_ATTEMPTS = 5
    def initialize(device)
      @device = device
      @connection = "USE #serial_device INSTEAD OF CONNECTION DIRECTLY"
      Struct.new("ProjectInfo", :public_key, :private_key) unless defined?(Struct::ProjectInfo)
    end

    def project_quantity
      serial_device do
        request_project_count
        sleep(0.5)
        read_project_count
      end
    end

    def project_info(project_index)
      serial_device do
        request_project_info(project_index)
        sleep(0.5)
        read_project_info
      end
    end

    def broadcast_status(public_key, status)
      serial_device do |connection|
        connection.puts(Message.project_status(public_key, status))
      end
    end

    private
      def request_project_count
        @connection.puts Message.project_qty_request
      end

      def read_project_count
        quantity_message = first_quantity_message_on_buffer
        if quantity_message.nil?
          raise AppropriateMessageTypeNotFound, "No 'quantity' message type found on serial buffer."
        end

        quantity_message.split(/#{Message::MSG_SEP}/).last.to_i
      end

      def first_quantity_message_on_buffer
        individual_messages.find {|m| m[0].chr == "N"}
      end

      def request_project_info(project_index)
        @connection.puts Message.project_info_request(project_index)
      end

      def read_project_info
        project_info = first_project_info_message_on_buffer
        if project_info.nil?
          raise AppropriateMessageTypeNotFound, "No 'project info' message type found on serial buffer."
        end

        Struct::ProjectInfo.new(*project_info.split(/#{Message::MSG_SEP}/).slice(1,3))
      end

      def first_project_info_message_on_buffer
        individual_messages.find {|m| m[0].chr == "I"}
      end

      def individual_messages
        @connection.read.scan(/#{Message::MSG_START}(.*?)#{Message::MSG_END}/).flatten
      end

      def serial_device(&block)
        @connection = SerialPort.new(@device, 9600)
        @connection.read_timeout = -1

        i = 1
        begin
          yield @connection
        rescue AppropriateMessageTypeNotFound => e
          i += 1
          retry unless i > MAX_SERIAL_DEVICE_ATTEMPTS
          raise e
        end
      ensure
        @connection.close
      end
  end
end
