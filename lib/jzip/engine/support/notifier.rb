require "rich/support/core/string/colorize"

module Jzip
  module Engine
    module Support
      module Notifier

        def notify(message)
          puts message.green
        end

      end
    end
  end
end