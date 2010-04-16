class ZigbeeDevice
  def initialize(output)
    @output = output
  end

  def project_quantity
    @output.puts "\002Q\003"
  end
end
