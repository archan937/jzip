require "thor"
require "rich/support/core/string/colorize"

require "jzip"

module Jzip
  class CLI < Thor

    class Error < StandardError; end

    desc "compile", "Compile Jzip assets"
    method_options [:minify, "-m"] => false, [:root_dir, "-r"] => :string, [:assets_dir, "-a"] => :string, [:output_dir, "-o"] => :string
    def compile
      configure_jzip
      Jzip::Engine.compile
    end

    desc "watch", "Watch Jzip assets and compile on change"
    method_options [:minify, "-m"] => false, [:root_dir, "-r"] => :string, [:assets_dir, "-a"] => :string, [:output_dir, "-o"] => :string
    def watch
      configure_jzip
      require "jzip/cli/guard"
      Guard::Jzip.compile_options = options
      locations = Jzip::Engine.template_locations.collect do |location|
        "watch(%r{^#{(location.is_a?(Hash) ? location.keys : location).gsub(File.expand_path("."), "").gsub(/^\//, "")}/.+\\.(js|jz)})"
      end
      Guard.setup
      Guard.start :guardfile_contents => <<-GUARD
        guard :jzip do
          #{locations.join "\n"}
        end
      GUARD
    end

  private

    def configure_jzip
      Jzip::Engine.options[:minify] = options.minify?
      Jzip::Engine.options[:root_dir] = options[:root_dir] unless options[:root_dir].to_s.empty?
      Jzip::Engine.options[:assets_dir] = options[:assets_dir] unless options[:assets_dir].to_s.empty?
      Jzip::Engine.options[:output_dir] = options[:output_dir] unless options[:output_dir].to_s.empty?
    end

    def method_missing(method, *args)
      raise Error, "Unrecognized command \"#{method}\". Please consult `jzip help`."
    end

  end
end