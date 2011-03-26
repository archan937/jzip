module Jzip
  module Engine
    module Support
      module Notifier

        def notify(message)
          string = wrap(message)
          case Jzip::Engine.options[:log_level]
          when :console
            puts string
          when :error, :info, :debug
            Rails.logger.send Jzip::Engine.options[:log_level], string
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