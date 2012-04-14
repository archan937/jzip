require "fileutils"
require "jzip/engine/support"
require "jzip/engine/template"
require "jzip/engine/requirement"

module Jzip
  module Engine
    extend self

    PREDEFINED_SETS = {"prototype" => %w(prototype effects dragdrop controls)}
    REG_EXPS = {:require_statement => /^\/\/\=\s*require\s*/, :partial => /^_/, :default_javascripts => /^\//}

    @options = {
      :minify => false
    }
    @template_locations = []

    attr_reader :root_dir, :options, :template_locations

    def root_dir=(value)
      @template_locations.delete assets_dir if root_dir
      @root_dir = value
      @template_locations.unshift assets_dir
      FileUtils.mkdir_p tmp_dir
    end

    def options=(value)
      @options.merge! value
    end

    def add_template_location(location)
      @template_locations << location
    end

    def assets_dir
      File.join root_dir, "assets", "jzip"
    end

    def tmp_dir
      File.join root_dir, "tmp", "jzip"
    end

    def compile
      parse_templates
      true
    end

  private

    self.root_dir = File.expand_path(".")

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
      Template.clear_instances
      template_refs.each do |source, target|
        Dir.glob(File.join(source, "**", "[^_]*.jz")).each do |template|
          Template.build(template, source, target).parse
        end
      end
    end

  end
end