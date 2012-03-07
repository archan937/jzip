require "rich/support/core/string/colorize"

module Jzip
  module Engine
    module Support
      module Notifier

        def notify(message)
          puts message.gsub(/^.*#{File.expand_path(".")}\//, "     create ").gsub("'", "").green if message.include? "Writing"
        end

      end
    end
  end
end