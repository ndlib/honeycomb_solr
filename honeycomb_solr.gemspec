# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'honeycomb_solr/version'

Gem::Specification.new do |spec|
  spec.name          = "honeycomb_solr"
  spec.version       = HoneycombSolr::VERSION
  spec.authors       = ["Jaron Kennel"]
  spec.email         = ["jaronkk@gmail.com"]

  spec.summary       = %q{Solr for Honeycomb}
  spec.description   = %q{Solr for Honeycomb}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jettywrapper", "~> 2.0.3"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
