lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "resque_reloader/version"

Gem::Specification.new do |spec|
  spec.name          = "resque-reloader"
  spec.version       = ResqueReloader::VERSION
  spec.authors       = ["yo_waka"]
  spec.email         = ["y.wakahara@gmail.com"]

  spec.summary       = %q{Hot reload resque job.}
  spec.description   = %q{Hot reload resque job.}
  spec.homepage      = "https://github.com/waka/resque-reloader"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", "~> 4.2"
  spec.add_runtime_dependency "resque", "~> 1.25.0"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
