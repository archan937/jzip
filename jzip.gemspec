# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jzip/version"

Gem::Specification.new do |s|
  s.name        = "jzip"
  s.version     = Jzip::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Engel"]
  s.email       = ["paul.engel@holder.nl"]
  s.homepage    = "http://codehero.es/rails_gems_plugins/jzip"
  s.summary     = %q{Javascript merging and compression for Rails Apps}
  s.description = %q{Jzip was created due to the need of simply merging and minifying Javascript files to reduce HTTP requests and file size of application assets. Using sprites for images and SASS for stylesheets only left javascripts not be optimized. AssetPackager almost suited the solution, but it hasn't got enough flexibility in configuration. So with AssetPackager (for minification) and SASS (for merging with templates) as inspiration, I came up with Jzip.}

  s.rubyforge_project = "jzip"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rich_support", "~> 0.1.0"
  s.add_dependency "thor"        , "~> 0.14.6"
end
