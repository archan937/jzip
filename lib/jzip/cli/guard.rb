require "guard"
require "guard/guard"

module Guard
  class Jzip < Guard
    def run_on_change(files)
      puts "Files changed: " + files.sort.inspect
      puts `jzip compile`
    end
  end
end