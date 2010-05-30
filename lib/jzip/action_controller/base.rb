
unless defined?(Jzip::CONTROLLER_HOOKED)
  Jzip::CONTROLLER_HOOKED = true
  
  module ActionController
  
    class Base
      alias_method :original_process, :process
      def process(*args)
        Jzip::Engine.compile_javascript_files
        original_process(*args)
      end
    end
  
  end
end
