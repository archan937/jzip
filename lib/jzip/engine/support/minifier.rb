module Jzip
  module Engine
    module Support
      module Minifier
        extend self

        def parse(source_file)
          target_file = derive_target(source_file)

          unless File.exists?(target_file)
            FileUtils.mkdir_p File.dirname(target_file)
            `ruby #{File.join(File.dirname(__FILE__), "jsmin.rb")} <#{source_file} >#{target_file}`
          end

          target_file
        end

      private

        def derive_target(source_file)
          source_file.gsub((source_file.match(REG_EXPS[:partial]) ? Engine.tmp_dir : Engine.root_dir).to_s, File.join(Engine.tmp_dir, "_minified_"))
        end

      end
    end
  end
end