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
  @device = FakeArduino.new
  @projects.each do |project|
    @device.register_project(project.public_key, project.private_key)
  end
end

When /^I run update_listeners$/ do
  @stdout_io = StringIO.new
  UpdateListeners::CLI.execute(@stdout_io, [])
  @stdout_io.rewind
  @output = @stdout_io.read.strip
end

Then /^it asks the serial device for the number of projects$/ do
  @output.should =~ "\002Q\003"
end

Then /^it asks the serial device for the CodeFumes authentication information for each project$/ do
  @output.should =~ "\002Q\003"
end

Then /^it should pass the following messages to the serial device:$/ do |table|
  pending # express the regexp above with the code you wish you had
end

Then /^the projects are removed$/ do
  @projects.each {|project| project.delete}
end
