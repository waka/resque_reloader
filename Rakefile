#
# Setup
#

load 'lib/tasks/resque_reloader.rake'


#
# Tests
#

require "rake/testtask"

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.verbose = true
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end
