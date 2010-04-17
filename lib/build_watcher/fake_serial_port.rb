module BuildWatcher
  class FakeSerialPort
    attr_reader :projects, :messages_sent

    def initialize
      @projects = []
      @messages_sent = ""
    end

    def register_project(public_key, private_key)
      @projects << [public_key, private_key]
    end

    def puts(message)
      @messages_sent << message
    end

    def close; end
  end
end
