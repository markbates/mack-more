# load tasks
Dir.glob(File.join(base, "tasks", "*.rake")).each do |f|
  load(f)
end