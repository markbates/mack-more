# require all supporting files
puts "in mack-javascript.rb"
dir_globs = Dir.glob(File.join(File.dirname(__FILE__), "generators", "**/*.rb"))
dir_globs.each do |d|
  require d
end

dir_globs = Dir.glob(File.join(File.dirname(__FILE__), "helpers", "**/*.rb"))
dir_globs.each do |d|
  require d
end

dir_globs = Dir.glob(File.join(File.dirname(__FILE__), "rendering", "**/*.rb"))
dir_globs.each do |d|
  require d
end

