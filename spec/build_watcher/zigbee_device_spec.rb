require 'spec/spec_helper.rb'

describe ZigbeeDevice do
  context "serial device support" do
    it "supports StringIO objects" do
      pending "Need to decide if this gets us anything we don't have already"
      zd = ZigbeeDevice.new(StringIO.new)
      lambda {
        zd.project_quantity
      }.should_not raise_error
    end

    it "supports raw device strings" do
      connection = FakeSerialPort.new
      connection.stub!(:read_timeout=)
      connection.stub!(:read).and_return("")
      connection.stub!(:read).and_return(Message.project_qty_response(@project_count), "")

      SerialPort.stub!(:new).and_return(connection)
      zd = ZigbeeDevice.new('/dev/something')
      lambda {
        zd.project_quantity
      }.should_not raise_error
    end
  end

  describe "#project_quantity" do
    before(:each) do
      @project_count = 3
      @connection = FakeSerialPort.new
      @connection.stub!(:read_timeout=)
      @connection.stub!(:read).and_return("")
      SerialPort.stub!(:new).and_return(@connection)
      @zigbee_device = ZigbeeDevice.new('/dev/some_device')
    end

    it "requests the number of projects being tracked" do
      @connection.stub!(:read).and_return(Message.project_qty_response(@project_count), "")
      @connection.should_receive(:puts).with(Message.project_qty_request)
      @zigbee_device.project_quantity
    end

    it "returns number of projects being tracked by the zigbee device" do
      @connection.stub!(:read).and_return(Message.project_qty_response(@project_count), "")
      @zigbee_device.project_quantity.should == @project_count
    end

    it "handles extra messages on the serial buffer" do
      project_info_message = Message.project_info_message('PUBLIC_KEY', 'PRIVATE_KEY')
      @connection.stub!(:read).and_return("#{project_info_message}#{Message.project_qty_response(@project_count)}#{project_info_message}", "")
      @zigbee_device.project_quantity.should == @project_count
    end

    it "handles multiple requests for quantity in a row" do
      project_info_message = Message.project_info_message('PUBLIC_KEY', 'PRIVATE_KEY')
      proj_qty_response = Message.project_qty_response(@project_count)
      @connection.stub!(:read).and_return("#{project_info_message}#{proj_qty_response}#{project_info_message}", "")

      @zigbee_device.project_quantity.should == @project_count
      new_project_count = 4
      proj_qty_response = Message.project_qty_response(new_project_count)
      @connection.stub!(:read).and_return("#{project_info_message}#{proj_qty_response}#{project_info_message}", "")
      @zigbee_device.project_quantity.should == new_project_count
    end

    context "when the serial buffer does not contain a quantity response" do
      it "raises a AppropriateMessageTypeNotFound error" do
        lambda {
          @zigbee_device.project_quantity
        }.should raise_error(AppropriateMessageTypeNotFound)
      end
    end
  end
end
