$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "external_mapping/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "external_mapping"
  s.version     = ExternalMapping::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of ExternalMapping."
  s.description = "TODO: Description of ExternalMapping."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.4"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
