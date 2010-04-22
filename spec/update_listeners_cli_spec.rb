require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'update_listeners/cli'

describe UpdateListeners::CLI, "execute" do
  def execute_script
    UpdateListeners::CLI.execute(STDOUT, ['-d', '/dev/some_device'])
  end

  before(:each) do
    @zigbee_device = BuildWatcher::ZigbeeDevice.new('/dev/something')
    @project = CodeFumes::Project.new(:public_key => 'pub', :private_key => 'priv')
    @project.stub!(:build_status).and_return("running")

    SerialPort.stub!(:new).and_return(FakeSerialPort.new)
    BuildWatcher::ZigbeeDevice.stub!(:new).and_return(@zigbee_device)
    CodeFumes::Project.stub!(:find).and_return(@project)
  end

  context "3 projects have been registered on the 'server' device and CodeFumes.com" do
    before(:each) do
      @project_quantity = 3
      Message.stub!(:project_qty_request).and_return(Message.project_qty_request!(@project_quantity))
      Message.stub!(:project_info_request).and_return(Message.project_info_request!(0,'pub','priv'))
    end

    it "requests the quantity of projects from the serial device" do
      @zigbee_device.should_receive(:project_quantity).and_return(@project_quantity)
      execute_script
    end

    it "requests the project information from the serial device for each project" do
      project_info = OpenStruct.new({:private_key => 'priv', :public_key => 'pub'})
      @zigbee_device.should_receive(:project_info).exactly(3).times.and_return(project_info)
      execute_script
    end

    it "it requests the project build status from CodeFumes for each project" do
      CodeFumes::Project.should_receive(:find).exactly(@project_quantity).times.and_return(@project)
      @project.should_receive(:build_status).exactly(@project_quantity).times.and_return('running')
      execute_script
    end

    it "it broadcasts the status of each project via the serial device" do
      @zigbee_device.should_receive(:broadcast_status).exactly(@project_quantity).times
      execute_script
    end
  end
end
