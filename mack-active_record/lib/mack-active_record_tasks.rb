require 'mack-orm_tasks'
Dir.glob(File.join(File.dirname(__FILE__), "mack-active_record", "tasks", "*.rake")).each do |f|
  load(f)
end