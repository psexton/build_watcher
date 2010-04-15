require 'spec/spec_helper.rb'

describe FakeArduino do
  describe "#register_project" do
    it "adds the specified public/private keypair to the list of projects" do
      @device = FakeArduino.new
      @public_key = "PUBLIC_KEY_HERE"
      @private_key = "PRIVATE_KEY_HERE"
      @device.register_project(@public_key, @private_key)
      @device.projects.first.should == [@public_key, @private_key]
    end
  end
end
