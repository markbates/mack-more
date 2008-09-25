fl = File.join(File.dirname(__FILE__), "mack-asset_packager")
Dir.glob(File.join(fl, "synthesis", "**", "*.rb")).each do |file|
  puts "requiring #{file}"
  require file
end
