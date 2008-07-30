# If the notifiers directory does not exist, create it.
FileUtils.mkdir_p(Mack::Paths.notifiers)

# Require all notifiers
Dir.glob(Mack::Paths.notifiers("**/*.rb")).each do |notifier|
  require notifier
end