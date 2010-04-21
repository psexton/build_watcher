require 'spec/spec_helper.rb'

describe FakeSerialPort do
  let(:device) { FakeSerialPort.new }

  describe "#register_project" do
    it "adds the specified public/private keypair to the list of projects" do
      public_key = "PUBLIC_KEY_HERE"
      private_key = "PRIVATE_KEY_HERE"
      device.register_project(public_key, private_key)
      device.projects.first.should == [public_key, private_key]
    end
  end

  describe '#messages_sent' do
    it "initializes #messages_sent to an empty String" do
      device.messages_sent.should == []
    end
  end

  describe '#puts' do
    it "stores supplied message into messages_sent" do
      device.puts Message.project_qty_request
      device.messages_sent.should == [Message.project_qty_request]
    end

    context "when requesting quantity" do
      it "adds a quantity response to the list of messages_received" do
        device.puts Message.project_qty_request!(3)
        device.messages_received.should include(Message.project_qty_response(3))
      end
    end
  end

  describe '#read' do
    it "returns the concatenated string of responses the device 'has received'" do
      device.puts Message.project_qty_request!(3)
      device.read.should == Message.project_qty_response(3)
    end

    it "clears the list of messages received (wiping the 'psuedo buffer')" do
      device.puts Message.project_qty_request!(3)
      device.read.should == Message.project_qty_response(3)
      device.read.should == ""
    end
  end
end
