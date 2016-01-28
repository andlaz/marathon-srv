# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marathon/srv/version'

Gem::Specification.new do |spec|
  spec.name          = "marathon-srv"
  spec.version       = Marathon::Srv::VERSION
  spec.authors       = ["Andras Szerdahelyi"]
  spec.email         = ["andras.szerdahelyi@gmail.com"]

  spec.summary       = %q{CLI to 'resolve' Marathon managed docker containers to slave ip and container ports to host ports }
  spec.description   = %q{Uses the Marathon API to match one or more ports set up under BRIDGE Docker networking for a Marathon application (grouped or not) to slave ip/s and slave (host) port/s}
  spec.homepage      = "https://github.com/andlaz/marathon-srv"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "json", "~> 1.8.3"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.22.6"
end
