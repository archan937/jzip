require "thor"
require "rich/support/core/string/colorize"

require "jzip"

module Jzip
  class CLI < Thor

    class Error < StandardError; end

    desc "compile", "Compile Jzip assets"
    def compile
      Jzip::Engine.compile
    end

    desc "watch", "Watch Jzip assets and compile on change"
    def watch
      require "jzip/cli/guard"

      Guard.setup
      Guard.start :guardfile_contents => <<-GUARD
        guard :jzip do
          watch(%r{^(#{Jzip::Engine.template_locations.collect(&:keys).flatten.uniq.join("|")})/.+$})
          callback(:run_on_change) { |file|
            puts "File changed: " + file.inspect
            `jzip compile`
          }
        end
      GUARD
    end

  private

    def method_missing(method, *args)
      raise Error, "Unrecognized command \"#{method}\". Please consult `jzip help`."
    end

  end
end