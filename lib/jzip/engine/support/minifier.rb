
module Jzip
  module Engine
    module Support
      module Minifier
        include Notifier
      
        extend self
      
        def parse(source_file)
          target_file = derive_target(source_file)
        
          unless File.exists?(target_file)
            notify "Minifying '#{source_file}'"
            FileUtils.mkdir_p File.dirname(target_file)
            `ruby #{File.join(File.dirname(__FILE__), "jsmin.rb")} <#{source_file} >#{target_file}`
          end
        
          target_file
        end
        
      private
      
        def derive_target(source_file)
          source_file.gsub source_file.match(REG_EXPS[:partial]) ? Engine.tmp_dir : Engine.root_dir, File.join(Engine.tmp_dir, "minified")
        end
    
      end
    end
  end
end
