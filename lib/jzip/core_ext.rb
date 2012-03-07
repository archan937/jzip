Dir[File.join(File.dirname(__FILE__), "core_ext", "*.rb")].each do |file|
  require file
end