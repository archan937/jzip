require "fileutils"
require "jzip/engine/support"
require "jzip/engine/template"
require "jzip/engine/requirement"

module Jzip
  module Engine
    include Support::Notifier

    extend self

    PREDEFINED_SETS = {"prototype" => %w(prototype effects dragdrop controls)}
    REG_EXPS = {:require_statement => /^\/\/\=\s*require\s*/, :partial => /^_/, :default_javascripts => /^\//}

    @options = {
      :minify => false,
      :always_update => true
    }

    attr_reader :root_dir, :options

    def root_dir=(value)
      @template_locations.clear
      @initial_compile = true
      @root_dir        = value
    end

    def options=(value)
      @options.merge! value
    end

    def add_template_location(location)
      @template_locations << location
    end

    def compile
      return unless @options[:always_update] or @initial_compile

      init if @initial_compile
      parse_templates
      @initial_compile = false

      true
    end

    def init
      @template_locations.unshift File.join(root_dir, "assets", "jzip")
      FileUtils.mkdir_p tmp_dir
    end

    def root_dir
      @root_dir || File.expand_path(".")
    end

    def tmp_dir
      File.join(root_dir, "tmp", "jzip")
    end

  private

    @template_locations = []
    @initial_compile    = true

    def template_refs
      Hash[
        *@template_locations.collect do |location|
          (location.is_a?(Hash) ? location.to_a : [location].flatten).collect do |x|
            ref = [x].flatten
            [ref.shift, ref.shift || File.join(root_dir, "assets")]
          end
        end.flatten
      ]
    end

    def parse_templates
      notify "Compiling templates..."

      Template.clear_instances
      template_refs.each do |source, target|
        Dir.glob(File.join(source, "**", "[^_]*.jz")).each do |template|
          Template.build(template, source, target).parse
        end
      end

      notify "Done"
    end

  end
end