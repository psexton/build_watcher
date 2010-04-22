begin
  require 'hoe'
rescue LoadError
  require 'rubygems'
  gem 'hoe', '>= 2.1.0'
  require 'hoe'
end

begin
  require "hanna/rdoctask"
rescue LoadError
  require 'rake/rdoctask'
end

require 'fileutils'
require './lib/build_watcher'


Hoe.plugin :git

$hoe = Hoe.spec 'build_watcher' do
  self.developer 'Tom Kersten', 'tom@whitespur.com'
  self.developer 'Michael Thies', 'michaelthies78@gmail.com'
  self.extra_deps     = [['codefumes','>= 0.1.8'], ['serialport', '= 1.0.2']]
  self.extra_dev_deps = [['hoe-git', '>= 1.3.0'], ['rspec', '1.3.0']]
  self.git_remotes    = ['gnr']
end

Dir['tasks/**/*.rake'].each { |t| load t }

# remove_task :default
# task :default => [:spec, :features]
