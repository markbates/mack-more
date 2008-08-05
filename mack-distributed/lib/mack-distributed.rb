base = File.join(File.dirname(__FILE__), "mack-distributed")

# load *.rb files
Dir.glob(File.join(base, "**", "*.rb")).each do |f|
  load(f)
end

# load tasks
Dir.glob(File.join(base, "tasks", "*.rake")).each do |f|
  load(f)
end