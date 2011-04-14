STDOUT.sync = true

require "fileutils"

module DummyApp
  extend self

  def setup(description, &block)
    log "\n".ljust 145, "="
    log "Setting up test environment for Rails #{major_rails_version} - #{description}\n"
    log "\n".rjust 145, "="

    restore_all
    stash_all
    yield self if block_given?
    @prepared = true

    log "\n".rjust 145, "="
    log "Environment for Rails #{major_rails_version} - #{description} is ready for testing"
    log "=" .ljust 145, "="
    require File.expand_path("../../test_helper.rb", __FILE__)
  end

  def prepare_database
    return if @db_prepared
    if @ran_generator
      stash "db/schema.rb", :schema
      run   "rake db:test:purge"
      run   "RAILS_ENV=test rake db:migrate"
    else
      run   "rake db:test:load"
    end
    @db_prepared = true
  end

  def restore_all(force = nil)
    if @prepared
      unless force
        log "Cannot (non-forced) restore files after having prepared the dummy app" unless force.nil?
        return
      end
    end
    restore "**/*.#{STASHED_EXT}"
  end

  def stash_all
    # this is gem specific
  end

  def generate_something
    # run "rails g some_generator"
    @ran_generator = true
  end

private

  STASHED_EXT = "stashed"

  def root_dir
    @root_dir ||= File.expand_path("../../../../dummy/", __FILE__)
  end

  def major_rails_version
    @major_rails_version ||= root_dir.match(/\/rails-(\d)\//)[1].to_i
  end

  def expand_path(path)
    path.match(root_dir) ?
      path :
      File.expand_path(path, root_dir)
  end

  def target(file)
    file.gsub /\.#{STASHED_EXT}$/, ""
  end

  def stashed(file)
    file.match(/\.#{STASHED_EXT}$/) ?
      file :
      "#{file}.#{STASHED_EXT}"
  end

  def restore(string)
    Dir[expand_path(string)].each do |file|
      if File.exists?(stashed(file))
        delete target(file)
        log "Restoring  #{stashed(file)}"
        File.rename stashed(file), target(file)
      end
    end
  end

  def stash(string, replacement = nil)
    Dir[expand_path(string)].each do |file|
      unless File.exists?(stashed(file))
        log "Stashing   #{target(file)}"
        File.rename target(file), stashed(file)
        replace(file, replacement)
      end
    end
  end

  def delete(string)
    Dir[expand_path(string)].each do |file|
      log "Deleting   #{file}"
      File.delete file
    end

    dirname = expand_path File.dirname(string)

    return unless File.exists?(dirname)
    Dir.glob("#{dirname}/*", File::FNM_DOTMATCH) do |file|
      return unless %w(. ..).include? File.basename(file)
    end

    log "Deleting   #{dirname}"
    Dir.delete dirname
  end

  def replace(file, replacement)
    content = case replacement
              when :gemfile
                <<-CONTENT.gsub(/^ {18}/, "")
                  source "http://rubygems.org"

                  gem "rails", "#{{2 => "2.3.10", 3 => "3.0.3"}[major_rails_version]}"

                  gem "rich_cms", :path => File.join(File.dirname(__FILE__), "..", "..", "..")

                  gem "shoulda"
                  gem "mocha"
                  gem "capybara"
                  gem "launchy"
                CONTENT
              end

    File.open target(file), "w" do |file|
      file << content
    end if content
  end

  def copy(source, destination)
    log "Copying    #{source} -> #{destination}"
    FileUtils.cp expand_path(source), expand_path(destination)
  end

  def run(command)
    return if command.to_s.gsub(/\s/, "").size == 0
    log "Executing  #{command}"
    `cd #{root_dir} && #{command}`
  end

  def log(string)
    puts string
  end

end