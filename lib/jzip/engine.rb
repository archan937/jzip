require "fileutils"
require "jzip/engine/support"
require "jzip/engine/template"
require "jzip/engine/requirement"

module Jzip
  module Engine
    extend self

    PREDEFINED_SETS = {"prototype" => %w(prototype effects dragdrop controls)}
    REG_EXPS = {:require_statement => /^\/\/\=\s*require\s*/, :partial => /^_/, :output_dir => /^\//}

    @options = Hash.new do |hash, key|
      case key
      when :minify
        hash[key] = false
      when :root_dir
        hash[key] = File.expand_path(".")
      when :assets_dir
        libs_jzip = File.join(hash[:root_dir], "libs", "jzip")
        hash[key] = File.exists?(libs_jzip) ? libs_jzip : File.join(hash[:root_dir], "assets", "jzip")
      when :output_dir
        public_javascripts = File.join(hash[:root_dir], "public", "javascripts")
        hash[key] = File.exists?(public_javascripts) ? public_javascripts : File.join(hash[:root_dir], "assets")
      end
    end

    attr_reader :options

    def template_locations
      @template_locations ||= [options[:assets_dir]]
    end

    def add_template_location(location)
      template_locations << location
    end

    def tmp_dir
      File.join options[:root_dir], "tmp", "jzip"
    end

    def compile
      parse_templates
      true
    end

  private

    def template_refs
      Hash[
        *template_locations.collect do |location|
          (location.is_a?(Hash) ? location.to_a : [location].flatten).collect do |x|
            ref = [x].flatten
            [ref.shift, ref.shift || options[:output_dir]]
          end
        end.flatten
      ]
    end

    def parse_templates
      FileUtils.mkdir_p tmp_dir unless File.exists? tmp_dir
      Template.clear_instances
      template_refs.each do |source, target|
        Dir.glob(File.join(source, "**", "[^_]*.jz")).each do |template|
          Template.build(template, source, target).parse
        end
      end
    end

  end
end