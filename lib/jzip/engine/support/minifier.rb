module Jzip
  module Engine
    module Support
      module Minifier
        extend self

        def parse(file)
          compressor = File.expand_path "../yuicompressor-2.4.2.jar", __FILE__
          `java -jar #{compressor} -v #{file} -o #{file}`
          true
        end

      end
    end
  end
end