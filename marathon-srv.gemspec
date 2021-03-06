# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marathon/srv/version'

Gem::Specification.new do |spec|
  spec.name          = "marathon-srv"
  spec.version       = Marathon::Srv::VERSION
  spec.authors       = ["Andras Szerdahelyi"]
  spec.email         = ["andras.szerdahelyi@gmail.com"]
  spec.license       = "MIT"

  spec.summary       = %q{A simple CLI/library to resolve (BRIDGE networked) ports of Docker containerized Marathon application tasks/instances to Mesos slave host names and host ports}
  spec.description   = %q{Uses the Marathon API to match one or more ports set up under BRIDGE Docker networking for a Marathon application to Mesos slave ip/s and host port/s}
  spec.homepage      = "https://github.com/andlaz/marathon-srv"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.2'
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "json", "~> 1.8.3"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-mocks", "~> 3.4.1"
  spec.add_development_dependency "webmock", "~> 1.22.6"
end
