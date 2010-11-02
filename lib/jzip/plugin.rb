
module Jzip
  module Plugin
    extend self

    def method_missing(method, *args)
      warn "DEPRECATION WARNING: Jzip::Plugin is deprecated (use Jzip::Engine instead) (called from #{caller.first.inspect})"
      Engine.send method, *args
    end

  end
end
