require 'rails'
require 'resque'

class ResqueReloader
  attr_reader :worker

  def start
    if defined?(Rails) && Rails.respond_to?(:application)
      prepare && watch && work
    else
      abort 'call your Rails application root directory'
    end
  end

  # Prepare worker
  def prepare
    queues = (ENV['QUEUES'] || ENV['QUEUE']).to_s.split(',')

    begin
      @worker = Resque::Worker.new(*queues)
      if ENV['LOGGING'] || ENV['VERBOSE']
        @worker.verbose = ENV['LOGGING'] || ENV['VERBOSE']
      end
      if ENV['VVERBOSE']
        @worker.very_verbose = ENV['VVERBOSE']
      end
      @worker.term_timeout = ENV['RESQUE_TERM_TIMEOUT'] || 4.0
      @worker.term_child = ENV['TERM_CHILD']
      @worker.run_at_exit_hooks = ENV['RUN_AT_EXIT_HOOKS']
    rescue Resque::NoQueueError => ex
      abort 'set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work'
    end

    if ENV['PIDFILE']
      File.open(ENV['PIDFILE'], 'w') { |f| f << @worker.pid }
    end

    true
  end

  # Start to watch files
  def watch
    paths = [ Rails.root.join('app'), Rails.root.join('lib') ]
    @worker.log "Watching files in #{paths}"

    reloader = ActiveSupport::FileUpdateChecker.new(paths) { rework }
    Rails.application.reloaders << reloader

    ActionDispatch::Reloader.to_prepare do
      reloader.execute_if_updated
    end

    true
  end

  def work
    @worker.log "Starting worker #{@worker}"
    @worker.work(ENV['INTERVAL'] || 5) # interval, will block

    true
  end

  # 1. ループを止める (= pausedにする)
  # 2. forkした子プロセスをkill
  # 3. 親プロセスでコード再読込
  # 4. ループ再度開始
  def rework
    @worker.log "Restarting worker #{@worker}"

    @worker.pause_processing   #1
    @worker.new_kill_child     #2
    @worker.unpause_processing #4
  end
end
