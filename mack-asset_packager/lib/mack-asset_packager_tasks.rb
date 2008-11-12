puts "***** #{File.basename(__FILE__)} ****"
# add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require File.join(File.dirname(__FILE__), 'gems')

Dir.glob(File.join(File.dirname(__FILE__), "mack-asset_packager", "tasks", "*.rake")).each do |f|
  load(f)
end