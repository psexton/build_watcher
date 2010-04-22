require 'spec/spec_helper.rb'

describe ZigbeeDevice do
  let(:connection) { FakeSerialPort.new }
  let(:zigbee_device) { ZigbeeDevice.new('/dev/some_device') }

  before(:each) do
    connection.stub!(:read_timeout=)
    connection.stub!(:read).and_return("")
    SerialPort.stub!(:new).and_return(connection)
  end

  context "serial device support" do
    it "supports raw device strings" do
      connection.stub!(:read).and_return(Message.project_qty_response(@project_count), "")
      lambda {
        zigbee_device.project_quantity
      }.should_not raise_error
    end
  end

  describe "#project_quantity" do
    before(:each) do
      @project_count = 3
    end

    it "requests the number of projects being tracked" do
      connection.stub!(:read).and_return(Message.project_qty_response(@project_count), "")
      connection.should_receive(:puts).with(Message.project_qty_request)
      zigbee_device.project_quantity
    end

    it "returns number of projects being tracked by the zigbee device" do
      connection.stub!(:read).and_return(Message.project_qty_response(@project_count), "")
      zigbee_device.project_quantity.should == @project_count
    end

    it "handles extra messages on the serial buffer" do
      project_info_message = Message.project_info_response('PUBLIC_KEY', 'PRIVATE_KEY')
      connection.stub!(:read).and_return("#{project_info_message}#{Message.project_qty_response(@project_count)}#{project_info_message}", "")
      zigbee_device.project_quantity.should == @project_count
    end

    it "handles multiple requests for quantity in a row" do
      project_info_message = Message.project_info_response('PUBLIC_KEY', 'PRIVATE_KEY')
      proj_qty_response = Message.project_qty_response(@project_count)
      connection.stub!(:read).and_return("#{project_info_message}#{proj_qty_response}#{project_info_message}", "")

      zigbee_device.project_quantity.should == @project_count
      new_project_count = 4
      proj_qty_response = Message.project_qty_response(new_project_count)
      connection.stub!(:read).and_return("#{project_info_message}#{proj_qty_response}#{project_info_message}", "")
      zigbee_device.project_quantity.should == new_project_count
    end

    context "when the serial buffer does not contain a quantity response" do
      it "raises a AppropriateMessageTypeNotFound error" do
        lambda {
          zigbee_device.project_quantity
        }.should raise_error(AppropriateMessageTypeNotFound)
      end
    end
  end

  describe "#project_info" do
    before(:each) do
      connection.stub!(:read).and_return(Message.project_info_response("public_key", "private_key"))
    end

    it "sends a project information message request to the serial port" do
      connection.should_receive(:puts).with(Message.project_info_request(0))
      zigbee_device.project_info(0)
    end

    it "reads the response from the serial device" do
      connection.should_receive(:read)
      zigbee_device.project_info(0)
    end

    it "returns a structure containing the public key information" do
      project_info = zigbee_device.project_info(0)
      project_info.public_key.should_not be_nil
    end

    it "returns a structure containing the private key information" do
      project_info = zigbee_device.project_info(0)
      project_info.private_key.should_not be_nil
    end
  end

  describe '#broadcast_status' do
    it "sends the project status message to the serial port" do
      connection.should_receive(:puts).with(Message.project_status("pub_key", "running"))
      zigbee_device.broadcast_status("pub_key", "running")
    end
  end
end
