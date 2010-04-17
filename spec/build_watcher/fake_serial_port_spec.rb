require 'spec/spec_helper.rb'

describe FakeSerialPort do
  describe "#register_project" do
    it "adds the specified public/private keypair to the list of projects" do
      device = FakeSerialPort.new
      public_key = "PUBLIC_KEY_HERE"
      private_key = "PRIVATE_KEY_HERE"
      device.register_project(public_key, private_key)
      device.projects.first.should == [public_key, private_key]
    end
  end

  describe '#messages_sent' do
    it "initializes #messages_sent to an empty String" do
      FakeSerialPort.new.messages_sent.should == ""
    end
  end

  describe '#puts' do
    it "stores supplied message into messages_sent" do
      device = FakeSerialPort.new
      message = "first message"

      device.puts message
      device.messages_sent.should == message
    end
  end
end
