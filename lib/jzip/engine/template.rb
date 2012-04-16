module Jzip
  module Engine
    class Template
      include Support::Notifier

      @@instances = {}
      attr_reader :target_file
      attr_accessor :file, :source, :target

      def self.clear_instances
        @@instances.clear
      end

      def self.build(*args)
        @@instances[args.first] ||= self.new(*args)
      end

      def initialize(file, source, target)
        self.file = file
        self.source = source
        self.target = target

        @file_name = File.basename(self.file, ".jz") + ".js"
        @target_dir = begin
          dir = partial? ? self.target.gsub(Engine.options[:root_dir], Engine.tmp_dir) : self.target
          File.dirname File.join dir, self.file.gsub(self.source, "")
        end
        @target_file = File.join @target_dir, @file_name

        scan_template
      end

      def parse
        @code ||= begin
                    write_file if requires_parsing?
                    File.read @target_file
                  end
      end

      def code
        parse
      end

    private

      def scan_template
        @requirements = []
        @segments     = File.readlines(self.file).inject([]) do |segments, line|
                          if line.jzip_require_statement?
                            derive_required_source(line.required_jzip_source).each do |file|
                              @requirements << Requirement.new(file, self.source, self.target)
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

        source_dirname = required_source.match(REG_EXPS[:output_dir]) ?
                           Engine.options[:output_dir] :
                           File.dirname(self.file)
        sources        = begin
                           if PREDEFINED_SETS.include?(basename)
                             PREDEFINED_SETS[basename].collect{|x| File.join(dirname, x)}
                           else
                             [required_source]
                           end
                         end

        sources.collect do |x|
          source = File.join(source_dirname, x)
          dir    = File.dirname  source
          base   = File.basename source

          [File.join(dir, "_#{base}.jz"),
           File.join(dir, "_#{base}.js"),
           File.join(dir,  "#{base}.jz"),
           File.join(dir,  "#{base}.js")].detect{|f| File.exists?(f)}
        end.compact
      end

      def write_file
        notify "  create #{@target_file.gsub(/#{File.expand_path(".")}\//, "")}"

        code = @segments.collect do |segment|
                 segment.is_a?(Requirement) ?
                   segment.code :
                   segment.join("")
               end.
               join("\n\n").
               gsub(/^\s*$\n{2,}/, "\n").
               strip.insert(0, "\n").insert(-1, "\n")

        FileUtils.mkdir_p @target_dir
        File.open(@target_file, "w") do |f|
          f.write code
        end

        Support::Minifier.parse @target_file if Jzip::Engine::options[:minify]
      end

      def requires_parsing?
        return true if outdated?

        modification_time = File.mtime(@target_file)

        @requirements.each{|x| x.parse}
        @requirements.any?{|x| x.newer? modification_time}
      end

      def outdated?
        missing? || (File.mtime(@target_file) < File.mtime(self.file))
      end

      def missing?
        !File.exists?(@target_file)
      end

      def partial?
        !!@file_name.match(REG_EXPS[:partial])
      end

    end
  end
end