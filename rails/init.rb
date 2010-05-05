
Dir.glob(File.join("vendor", "plugins", "jzip", "lib", "**", "*.rb")).each do |file|
  require file unless file.include?("support")
end

Jzip::Plugin.init