
module Jzip
  module Controller
    
    module ::ActionController
      class Base
  
        alias_method :original_process, :process
        def process(*args)
          Jzip::Plugin.compile_javascript_files
          original_process(*args)
        end
  
      end
    end
    
  end
end
