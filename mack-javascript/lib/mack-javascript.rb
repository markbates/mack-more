require File.join(File.dirname(__FILE__), 'gems')

# require all supporting files
fl = File.join(File.dirname(__FILE__), "mack-javascript")

dir_globs = Dir.glob(File.join(fl, "generators", "**/*.rb"))
dir_globs.each do |d|
  require d
end

dir_globs = Dir.glob(File.join(fl, "helpers", "**/*.rb"))
dir_globs.each do |d|
  require d
end

dir_globs = Dir.glob(File.join(fl, "rendering", "**/*.rb"))
dir_globs.each do |d|
  require d
end

dir_globs = Dir.glob(File.join(fl, "view_helpers", "**/*.rb"))
dir_globs.each do |d|
  require d
end

if configatron.mack.js_framework
  assets_mgr.defaults do |a|
    a.add_js "#{configatron.mack.js_framework.to_s}.js"
  end
end