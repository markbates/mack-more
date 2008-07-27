Dir.glob(File.join(File.dirname(__FILE__), "mack-data_mapper", "tasks", "*.rake")).each do |f|
  load(f)
end