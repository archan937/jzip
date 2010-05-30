
module Jzip
  module Engine
    include Support::Notifier
    
    extend self
    
    PREDEFINED_SETS = {"defaults" => %w(prototype effects dragdrop controls application)}
    REG_EXPS        = {:require_statement => /^\/\/\=\s*require\s*/, :partial => /^_/, :default_javascripts => /^\//}
    TMP_DIR         = File.join(RAILS_ROOT, "tmp", "jzip")
    
    @options = {
      :minify        => RAILS_ENV == "production",
      :always_update => RAILS_ENV != "production"
    }
    attr_reader :options
    
    def init
      FileUtils.mkdir_p TMP_DIR
    end
    
    def options=(value)
      @options.merge! value
    end
    
    def add_template_location(location)
      @template_locations << location
    end
    
    def compile_javascript_files
      return unless @options[:always_update] or @initial_compile
      
      parse_templates
      @initial_compile = false
    end
    
  private
    
    @template_locations = [File.join(RAILS_ROOT, "assets", "jzip")]
    @initial_compile    = true
    
    def template_refs
      Hash[
        *@template_locations.collect do |location|
          (location.is_a?(Hash) ? location.to_a : [location].flatten).collect do |x|
            ref = [x].flatten
            [ref.shift, ref.shift || File.join(RAILS_ROOT, "public", "javascripts")]
          end
        end.flatten
      ]
    end
    
    def parse_templates
      notify "Compiling templates..."
      
      Template.clear_instances
      template_refs.each do |source, target|
        Dir.glob(File.join(source, "**", "[^_]*.jz")).each do |template|
          Template.build(template, source, target).parse
        end
      end
      
      notify "Done"
    end
    
  end  
end
