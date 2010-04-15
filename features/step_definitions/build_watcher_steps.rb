Given /^the following projects are registered in the serial device:$/ do |projects|
  @device = FakeArduino.new
  projects.hashes.each do |project|
    @device.register_project(project['public_key'], project['private_key'])
  end
end

Given /^the projects have the following build statuses:$/ do |projects|
  projects.hashes.each do |project|
    project_stubs = {:public_key => project['public_key'], :build_status => project['status']}
    mock_project = mock('Mock CodeFumes Project', project_stubs)
    CodeFumes::Project.stub!(:find).with(project['public_key']).and_return(mock_project)
  end
end
