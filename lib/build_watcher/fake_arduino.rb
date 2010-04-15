class FakeArduino
  attr_reader :projects

  def initialize
    @projects = []
  end

  def register_project(public_key, private_key)
    @projects << [public_key, private_key]
  end
end

