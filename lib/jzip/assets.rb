
module Jzip
  module Assets
    include Support::Notifier

    extend self
    
    def install_defaults
      create_default_template_location

      File.open(File.join(template_dir, "defaults.jz"), "w") do |f|
        f.write("\n//= require /defaults\n") 
      end

      notify "Done"
    end
    
  private
  
    def create_default_template_location
      notify "Creating default template location..."
      FileUtils.mkdir_p default_template_location
    end
    
    def default_template_location
      File.join Jzip::Engine.root_dir, "assets", "jzip"
    end
    
  end
end
