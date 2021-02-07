$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "data_snapshots/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "data_snapshots"
  spec.version     = DataSnapshots::VERSION
  spec.authors     = ["k-p-jones"]
  spec.email       = ["kenjones620@yahoo.co.uk"]
  spec.homepage    = "https://github.com/k-p-jones/data_snapshots"
  spec.summary     = "Data snapshots for Rails apps."
  spec.description = "Flexible data snapshoting for Ruby on Rails."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.0.0"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"
end
