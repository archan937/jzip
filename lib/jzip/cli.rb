require "thor"
require "rich/support/core/string/colorize"

module Jzip
  class CLI < Thor

    class Error < StandardError; end

    default_task :compile

    desc "compile", "Compile Jzip templates"
    method_options [:verbose, "-v"] => false
    def compile
      runner "Jzip::Engine.compile_javascript_files"
    end

    desc "install", "Create the Jzip default template location and defaults.jz template"
    method_options [:verbose, "-v"] => false
    def install
      runner "Jzip::Assets.install_defaults"
    end

  private

    def method_missing(method, *args)
      raise Error, "Unrecognized command \"#{method}\". Please consult `jzip help`."
    end

    def runner(ruby_code)
      system "#{rails_runner} 'Jzip::Engine.options[:log_level] = #{(:console if options.verbose?).inspect}; #{ruby_code}'"
    end

    def rails_runner
      if File.exists? "script/runner"
        return "script/runner"
      elsif File.exists? "script/rails"
        return "rails runner"
      end

      raise Error, "Could not start Rails environment. Is this really a Rails application dir?"
    end

  end
end