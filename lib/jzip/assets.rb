
module Jzip
  module Assets
    extend self

    def install_defaults
      puts "Installing defaults..."

      create_default_template_location
      File.open(File.join(default_template_location, "defaults.jz"), "w") do |f|
        f.write("\n//= require /defaults\n")
      end

      puts "Done"
    end

  private

    def create_default_template_location
      FileUtils.mkdir_p default_template_location
    end

    def default_template_location
      File.join Jzip::Engine.root_dir, "assets", "jzip"
    end

  end
end
