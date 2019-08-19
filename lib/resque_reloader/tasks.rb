namespace :resque do
  desc 'Start a Resque worker with hot reload'
  task :work_with_reload => [] do
    reloader = ResqueReloader.new
    reloader.start
  end
end
