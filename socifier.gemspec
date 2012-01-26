# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "socifier/version"

Gem::Specification.new do |s|
  s.name        = "socifier"
  s.version     = Socifier::VERSION
  s.authors     = ["Albert Callarisa Roca"]
  s.email       = ["albert@acroca.com"]
  s.homepage    = "http://github.com/acroca/socifier-gem"
  s.summary     = %q{Socifier.com API client}
  s.description = %q{Provides an easy DSL to communicate with the Socifier.com API}

  s.rubyforge_project = "socifier"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rest-client"
end
