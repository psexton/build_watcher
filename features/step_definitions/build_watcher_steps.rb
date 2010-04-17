Given /^there are projects with the following public keys set up at Codefumes.com:$/ do |projects|
  repository = CodeFumesHarvester::SourceControl.new('./')
  payload_content = repository.payload_between("HEAD^", "HEAD")

  @projects = projects.hashes.map do |project_hash|
    project = CodeFumes::Project.new(:public_key => project_hash["public_key"])
    unless project.save
      raise "Project not saved to test.codefumes.com"
    end

    payload = CodeFumes::Payload.new(:public_key  => project.public_key,
                                     :private_key => project.private_key,
                                     :content     => payload_content
                                    )
    raise "Payload not saved" unless payload.save
    project
  end
end

Given /^the projects have the following build statuses:$/ do |projects|
  projects.hashes.each do |project_info|
    project = CodeFumes::Project.find(project_info["public_key"])
    build = CodeFumes::Build.new(:public_key  => project.public_key,
                                 :private_key => project.private_key,
                                 :commit_identifier => CodeFumes::Commit.latest_identifier(project.public_key),
                                 :name => 'ie7',
                                 :started_at => Time.now,
                                 :state => 'running'
                                )
    raise "Build not saved" unless build.save
  end
end

Given /^the projects are all being tracked on the serial device$/ do
  @device = FakeSerialPort.new
  @projects.each do |project|
    @device.register_project(project.public_key, project.private_key)
  end
end

When /^I run update_listeners$/ do
  # Overridden so our response is auto-populated for us in #puts
  Message.stub!(:project_qty_request).and_return(Message.project_qty_request!(@projects.size))
  SerialPort.stub!(:new).and_return(@device)
  UpdateListeners::CLI.execute('/dev/someport', [])
end

Then /^it broadcasts the build status for each project via the serial port$/ do
  @projects.each do |project|
    status_msg = Message.project_status(project.public_key, project.build_status)
    debugger
    @device.messages_sent.should include(status_msg)
  end
end
Then /^the projects are removed$/ do
  @projects.each {|project| project.delete}
end
