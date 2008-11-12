puts "***** #{File.basename(__FILE__)} ****"
# add_gem_path(File.expand_path(File.join(File.dirname(__FILE__), 'gems')))

require File.join(File.dirname(__FILE__), 'gems')

[:core, :aggregates, :migrations, :serializer, :timestamps, :validations, :observer, :types].each do |g|
  require "dm-#{g}" unless g == :types
end

require 'mack-orm_tasks'
Dir.glob(File.join(File.dirname(__FILE__), "mack-data_mapper", "tasks", "*.rake")).each do |f|
  load(f)
end