require 'mack-orm_tasks'

require File.join(File.dirname(__FILE__), 'gems')

[:core, :aggregates, :migrations, :serializer, :timestamps, :validations, :observer, :types].each do |g|
  require "dm-#{g}" unless g == :types
end

Dir.glob(File.join(File.dirname(__FILE__), "mack-data_mapper", "tasks", "*.rake")).each do |f|
  load(f)
end