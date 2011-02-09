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

task :test do
  Rake::Task["test:all"].execute
end

task :restore do
  Rake::Task["restore:all"].execute
end

task :stash do
  Rake::Task["stash:all"].execute
end

namespace :test do
  desc "Test the jzip plugin in Rails 2 and 3."
  task :all do
    system "rake test:rails-2"
    system "rake test:rails-3"
  end
  desc "Test the jzip plugin in Rails 2."
  Rake::TestTask.new(:"rails-2") do |t|
    t.libs    << "lib"
    t.libs    << "test"
    t.pattern  = "test/rails-2/test/{,/*/**}/*_test.rb"
    t.verbose  = true
  end
  desc "Test the jzip plugin in Rails 3."
  Rake::TestTask.new(:"rails-3") do |t|
    t.libs    << "lib"
    t.libs    << "test"
    t.pattern  = "test/rails-3/test/{,/*/**}/*_test.rb"
    t.verbose  = true
  end
end

namespace :restore do
  desc "Restore the Rails 2 and 3 dummy apps."
  task :all do
    system "rake restore:rails-2"
    system "rake restore:rails-3"
  end
  desc "Restore the Rails 2 dummy app."
  task :"rails-2" do
    require "test/rails-2/dummy/test/support/dummy_app.rb"
    DummyApp.restore_all
  end
  desc "Restore the Rails 3 dummy app."
  task :"rails-3" do
    require "test/rails-3/dummy/test/support/dummy_app.rb"
    DummyApp.restore_all
  end
end

namespace :stash do
  desc "Stash the Rails 2 and 3 dummy apps."
  task :all do
    system "rake stash:rails-2"
    system "rake stash:rails-3"
  end
  desc "Stash the Rails 2 dummy app."
  task :"rails-2" do
    require "test/rails-2/dummy/test/support/dummy_app.rb"
    DummyApp.stash_all
  end
  desc "Stash the Rails 3 dummy app."
  task :"rails-3" do
    require "test/rails-3/dummy/test/support/dummy_app.rb"
    DummyApp.stash_all
  end
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