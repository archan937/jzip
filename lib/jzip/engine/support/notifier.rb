require "rich/support/core/string/colorize"

module Jzip
  module Engine
    module Support
      module Notifier

        def notify(message)
          string = wrap(message)
          case defined?(Rails) ? Jzip::Engine.options[:log_level] : :colorize
          when :colorize
            puts message.gsub(/^.*#{File.expand_path(".")}\//, "     create ").gsub("'", "").green if message.include? "Writing"
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