
module Jzip
  module Engine
    
    Template = Struct.new(:template, :source, :target) do
    
      include Support::Notifier
      
      @@instances = {}
      attr_reader :target_file
      
      def self.clear_instances
        @@instances.clear
      end
      
      def self.build(*args)
        @@instances[args.first] ||= self.new(*args)
      end
      
      def initialize(*args)
        super

        @file_name   = File.basename(self.template, ".jz") + ".js"
        @target_dir  = File.dirname File.join(self.target, self.template.gsub(self.source, ""))
        if partial?
          @target_dir.gsub! RAILS_ROOT, TMP_DIR
        end
        @target_file = File.join @target_dir, @file_name
        
        scan_template
      end
      
      def parse
        unless requires_parsing?
          notify "Skipping '#{self.template}'"
        else
          notify "Parsing '#{self.template}'"
          
          @code = @segments.collect do |segment|
                    segment.is_a?(Requirement) ?
                      segment.code : 
                      segment.join("")
                  end.join("\n").gsub(/(^\s+$){3,}/, "\n\n").gsub(/^\n+/, "\n") + "\n"
      
          write_file
        end
        @code ||= File.open(@target_file).read
      end
      
      def code
        parse
      end
      
      def outdated?(mtime = nil)
        return true unless target_file?
        File.mtime(@target_file) < (mtime || File.mtime(self.template))
      end
      
      def partial?
        !!@file_name.match(REG_EXPS[:partial])
      end
      
    private
      
      def scan_template
        @requirements = []
        @segments     = File.open(self.template).readlines.inject([]) do |segments, line|
                          if line.jzip_require_statement?
                            derive_required_source(line.required_jzip_source).each do |file|
                              @requirements << Requirement.new(file, self.source, self.target, line.overrule_jzip_minification?)
                              segments      << @requirements.last
                            end
                          else
                            segments << [] unless segments.last.is_a?(Array)
                            segments.last << line
                          end
                          segments
                        end
      end
      
      def derive_required_source(required_source)
        basename = File.basename required_source
        dirname  = File.dirname  required_source
        
        source_dirname = required_source.match(REG_EXPS[:default_javascripts]) ?
                           File.join(RAILS_ROOT, "public", "javascripts") :
                           File.dirname(self.template)
        sources        = begin
                           if PREDEFINED_SETS.include?(basename)
                             PREDEFINED_SETS[basename].collect{|x| File.join(dirname, x)}
                           else
                             [required_source]
                           end
                         end
                         
        sources.collect do |x|
          [File.join(source_dirname, "_#{x}.jz"),
           File.join(source_dirname,  "#{x}.jz"),
           File.join(source_dirname,  "#{x}.js")].detect{|x| File.exists?(x)}
        end.compact
      end
      
      def write_file
        FileUtils.mkdir_p @target_dir
        File.open(@target_file, "w") do |f|
          f.write @code
        end
      end
      
      def requires_parsing?
        return true if outdated?

        modification_time = File.mtime(@target_file)
        
        @requirements.each{|x| x.parse}
        @requirements.any?{|x| x.newer? modification_time}
      end
      
      def target_file?
        File.exists? @target_file
      end
         
    end
    
  end
end
