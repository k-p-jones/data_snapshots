$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "data_snapshots/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "data_snapshots"
  spec.version     = DataSnapshots::VERSION
  spec.authors     = ["k-p-jones"]
  spec.email       = ["kenjones620@yahoo.co.uk"]
  spec.homepage    = ""
  spec.summary     = ""
  spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 6.0.3.3"

  spec.add_development_dependency "sqlite3"
end
