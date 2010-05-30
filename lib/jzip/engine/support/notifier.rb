
module Jzip
  module Engine
    module Support
      module Notifier
    
        def notify(message)
          RAILS_DEFAULT_LOGGER.info "== JZIP: #{message}"
        end
    
      end
    end
  end
end
