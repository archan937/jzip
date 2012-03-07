require "thor"
require "rich/support/core/string/colorize"

require "jzip"

module Jzip
  class CLI < Thor

    class Error < StandardError; end

    default_task :compile

    desc "compile", "Compile Jzip assets"
    def compile
      Jzip::Engine.compile
    end

  private

    def method_missing(method, *args)
      raise Error, "Unrecognized command \"#{method}\". Please consult `jzip help`."
    end

  end
end