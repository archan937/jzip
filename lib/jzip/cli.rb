require "thor"
require "rich/support/core/string/colorize"
require "jzip"

module Jzip
  class CLI < Thor

    class Error < StandardError; end

    desc "compile", "Compile Jzip templates"
    method_options [:verbose, "-v"] => false
    def compile
      Jzip::Engine.compile_javascript_files
    end

  private

    def method_missing(method, *args)
      raise Error, "Unrecognized command \"#{method}\". Please consult `jzip help`."
    end

  end
end