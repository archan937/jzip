
module Jzip
  module Engine
    module Support
      module Notifier

        def notify(message)
          string = wrap(message)
          case Jzip::Engine.options[:logger]
          when :puts
            puts string
          when :logger
            Rails.logger.debug(string)
          end
        end

      private

        def wrap(message)
          "== JZIP: #{message}"
        end

      end
    end
  end
end
