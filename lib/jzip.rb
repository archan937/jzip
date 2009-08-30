module Jzip
  module Controller
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        before_filter :compile_javascript_files
      end
    end

    module InstanceMethods
      def compile_javascript_files
        Jzip::Plugin.compile_javascript_files
      end
    end
  end

  module Plugin
    extend self
    
    @options = {
      :template_location => File.join(RAILS_ROOT, "assets", "jzip"),
      :minify            => RAILS_ENV == "production",
      :always_update     => RAILS_ENV != "production"
    }
    attr_reader :options
    
    def options=(value)
      @options.merge!(value)
    end
    
    def compile_javascript_files
      return unless @options[:always_update] or @initial_compile
      template_refs.each{|source, target| parse_templates(source, target)}
      @initial_compile = false
    end
    
  private
    
    @initial_compile = true
    
    def template_refs
      template_location = options[:template_location]
      Hash[
        *(template_location.is_a?(Hash) ? template_location.to_a : [template_location].flatten).collect do |location|
          ref = [location].flatten
          [ref.shift, ref.shift || File.join(RAILS_ROOT, "public", "javascripts")]
        end.flatten
      ]
    end
    
    def parse_templates(source, target)
      Dir.glob(File.join(source, "**", "*.jz")).each do |template|
        parse(template, source, target)
      end
    end
    
    def parse(template, source, target)
      require_regexp = /^\/\/\=\s*require\s*/
      
      code = File.open(template).readlines.collect do |line|
        if line.strip.match(require_regexp)
          arg = line.strip.gsub(require_regexp, "").strip
          requirements(template, arg).collect{|x| File.open(x).read}.join("\n\n") + "\n\n"
        else
          line
        end
      end
      
      publish(template, code, source, target)
    end
    
    def requirements(template, arg)
      defaults = %w(prototype effects dragdrop controls)
      defaults << "application" if File.exists?(File.join(RAILS_ROOT, "public", "javascripts", "application.js"))
      
      arg == "defaults" ?
        defaults.collect{|x| File.join(RAILS_ROOT, "public", "javascripts", "#{x}.js")} :
        [File.join(File.dirname(template), "#{arg}.js")]
    end
    
    def publish(template, code, source, target)
      tmp_dir     = File.join(RAILS_ROOT, "tmp", "jzip")
      target_dir  = File.dirname(File.join(target, template.gsub(source, "")))
      
      file_name   = "#{File.basename(template, ".jz")}.js"
      tmp_file    = File.join(tmp_dir, file_name)
      target_file = File.join(target_dir, file_name)
      
      FileUtils.mkdir_p(tmp_dir)
      FileUtils.mkdir_p(target_dir)
      File.open(tmp_file, "w") do |f|
        f.write(code)
      end
      
      if options[:minify]
        tmp_min_file = tmp_file.gsub(".js", "-min.js")
        
        `ruby #{File.join(File.dirname(__FILE__), "support", "jsmin.rb")} <#{tmp_file} >#{tmp_min_file}`

        FileUtils.mv tmp_min_file, target_file
        File.delete  tmp_file
      else
        FileUtils.mv tmp_file, target_file
      end
    end
  end  
end
