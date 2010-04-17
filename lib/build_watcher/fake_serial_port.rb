module BuildWatcher
  class FakeSerialPort
    attr_reader :projects, :messages_sent, :messages_received
    attr_accessor :read_timeout

    def initialize
      @projects = []
      @messages_sent = []
      @messages_received = []
      @serial_buffer = []
    end

    def register_project(public_key, private_key)
      @projects << [public_key, private_key]
    end

    # If an array is passed in, the first element is "sent"
    # and the second element is added to the list of messages
    # recieved
    def puts(content)
      message, response = content
      @messages_sent << message

      unless response.nil?
        @messages_received << response
        @serial_buffer << response
      end

      message
    end

    def read
      buffers_contents = @serial_buffer.join
      @serial_buffer = []
      buffers_contents
    end

    def close; end
  end
end
