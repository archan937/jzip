
namespace :jzip do
  namespace :assets do
    
    desc "Create the Jzip default template location and defaults.jz template"
    task :install => :environment do
      Jzip::Assets.install
    end
    
  end
end
