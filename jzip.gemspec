# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Paul Engel"]
  gem.email         = ["paul.engel@holder.nl"]
  gem.description   = %q{Jzip was created due to the need of simply merging and minifying Javascript files to reduce HTTP requests and file size of application assets. Using sprites for images and SASS for stylesheets only left javascripts not be optimized. AssetPackager almost suited the solution, but it hasn't got enough flexibility in configuration. So with AssetPackager (for minification) and SASS (for merging with templates) as inspiration, I came up with Jzip.}
  gem.summary       = %q{Javascript merging and compression within Ruby}
  gem.homepage      = "http://codehero.es/rails_gems_plugins/jzip"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "jzip"
  gem.require_paths = ["lib"]
  gem.version       = File.read(File.expand_path("../VERSION", __FILE__)).strip

  gem.add_dependency "rich_support", "0.1.2"
  gem.add_dependency "thor"        , "0.14.6"
  gem.add_dependency "guard"
end