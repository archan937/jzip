
module Jzip
  module Test
    module Setup

      def self.included(base)
        require "jzip"
        Jzip::Engine.root_dir = File.join(File.dirname(__FILE__), "rails_root")
      end

    end
  end
end
