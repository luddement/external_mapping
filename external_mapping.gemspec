$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "external_mapping/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "external_mapping"
  s.version     = ExternalMapping::VERSION
  s.authors     = ["Ludvig Dickman"]
  s.email       = ["luddement@gmail.com"]
  s.homepage    = "https://github.com/luddement/external_mapping"
  s.summary     = "Map and sync external sources with active record objects."
  s.description = "Map and sync external sources with active record objects"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
