require "rake"
require "rake/testtask"
require "rake/rdoctask"

begin
  require "jeweler"
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "jzip"
    gemspec.summary     = "Javascript merging and compression for Rails Apps"
    gemspec.description = "Jzip was created due to the need of simply merging and minifying Javascript files to reduce HTTP requests and file size of application assets. Using sprites for images and SASS for stylesheets only left javascripts not be optimized.
                           AssetPackager almost suited the solution, but it hasn't got enough flexibility in configuration. So with AssetPackager (for minification) and SASS (for merging with templates) as inspiration, I came up with Jzip."
    gemspec.email       = "paul.engel@holder.nl"
    gemspec.homepage    = "http://github.com/archan937/jzip"
    gemspec.author      = "Paul Engel"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

desc "Default: run unit tests."
task :default => :test

desc "Test the jzip plugin."
Rake::TestTask.new(:test) do |t|
  t.libs    << "lib"
  t.libs    << "test"
  t.pattern  = "test/**/*_test.rb"
  t.verbose  = true
end

desc "Generate documentation for the jzip plugin."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "Jzip"
  rdoc.options << "--line-numbers" << "--inline-source"
  rdoc.rdoc_files.include "README"
  rdoc.rdoc_files.include "MIT-LICENSE"
  rdoc.rdoc_files.include "lib/**/*.rb"
end