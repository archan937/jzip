
namespace :jzip do
  namespace :install do
    
    desc "Create the Jzip default template location and defaults.jz template"
    task :defaults => :environment do
      Jzip::Assets.install_defaults
    end
    
  end
end
