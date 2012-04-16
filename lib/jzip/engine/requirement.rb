module Jzip
  module Engine

    Requirement = Struct.new(:file, :source, :target, :overrule_minification) do

      def newer?(mtime)
        mtime < File.mtime(target_file)
      end

      def parse
        @code ||= begin
                    template.parse unless plain_javascript?
                    Support::Minifier.parse target_file if minify?
                    File.read target_file
                  end
      end

      def code
        parse
      end

    private

      def plain_javascript?
        File.extname(self.file) == ".js"
      end

      def minify?
        Jzip::Engine::options[:minify] && !@overrule_minification
      end

      def template
        @template ||= Template.build(self.file, self.source, self.target) unless plain_javascript?
      end

      def target_file
        plain_javascript? ? self.file : template.target_file
      end

    end

  end
end