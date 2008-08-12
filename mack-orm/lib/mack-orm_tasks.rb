Dir.glob(File.join(File.dirname(__FILE__), "mack-orm", "tasks", "*.rake")).each do |f|
  load(f)
end