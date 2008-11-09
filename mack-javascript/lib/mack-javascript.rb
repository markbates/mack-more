puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))


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
  case configatron.mack.js_framework.to_s
    when 'prototype'
      file_list = ["controls.js", "dragdrop.js", "effects.js", "prototype.js"]
    when 'jquery'
      file_list = ["jquery.js", "jquery-ui.js", "jquery-fx.js"]
  end
  
  file_list.each do |file|
    assets_mgr.defaults do |a|
      a.add_js file
    end
  end
end