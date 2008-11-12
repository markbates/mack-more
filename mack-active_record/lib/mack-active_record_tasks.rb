require 'mack-orm_tasks'

require File.join(File.dirname(__FILE__), 'gems')

Dir.glob(File.join(File.dirname(__FILE__), "mack-active_record", "tasks", "*.rake")).each do |f|
  load(f)
end