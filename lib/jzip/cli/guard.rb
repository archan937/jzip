require "guard"
require "guard/guard"

module Guard
  class Jzip < Guard

    def self.compile_options
      @compile_options || {}
    end

    def self.compile_options=(options)
      @compile_options = options
    end

    def run_on_change(files)
      options = Jzip.compile_options

      opts = []
      opts << "-m" if options.minify?
      opts << "--root_dir=#{options[:root_dir]}" unless options[:root_dir].to_s.empty?
      opts << "--assets_dir=#{options[:assets_dir]}" unless options[:assets_dir].to_s.empty?
      opts << "--output_dir=#{options[:output_dir]}" unless options[:output_dir].to_s.empty?

      puts "Files changed: " + files.sort.inspect
      puts `jzip compile #{opts.join(" ")}`
    end

  end
end