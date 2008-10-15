# If the notifiers directory does not exist, create it.
FileUtils.mkdir_p(Mack::Paths.notifiers)

# Require all notifiers
Mack.search_path(:app).each do |path|
  Dir.glob(File.join(path, 'notifiers', "**/*.rb")).each do |notifier|
    require File.expand_path(notifier)
  end
end