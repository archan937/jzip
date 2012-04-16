module Jzip
  module Engine

    Requirement = Struct.new(:file, :source, :target) do

      def parse
        @code ||= begin
                    template.parse unless plain_javascript?
                    File.read target_file
                  end
      end

      def code
        parse
      end

      def newer?(mtime)
        mtime < File.mtime(target_file)
      end

    private

      def plain_javascript?
        File.extname(self.file) == ".js"
      end

      def target_file
        plain_javascript? ? self.file : template.target_file
      end

      def template
        @template ||= Template.build(self.file, self.source, self.target) unless plain_javascript?
      end

    end

  end
end