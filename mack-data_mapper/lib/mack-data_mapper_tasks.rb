puts "***** #{File.basename(__FILE__)} ****"
add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require 'mack-orm_tasks'
Dir.glob(File.join(File.dirname(__FILE__), "mack-data_mapper", "tasks", "*.rake")).each do |f|
  load(f)
end