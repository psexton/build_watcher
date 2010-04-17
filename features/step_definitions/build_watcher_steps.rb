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
  @stdout_io = StringIO.new
  UpdateListeners::CLI.execute(@stdout_io, [])
  @stdout_io.rewind
  @messages_sent = @stdout_io.read.strip
end

Then /^it passes the following update messages to the serial device:$/ do |table|
  @messages_sent.should =~ /\002Q\003/
end

Then /^the projects are removed$/ do
  @projects.each {|project| project.delete}
end
