# If the mailers directory does not exist, create it.
FileUtils.mkdir_p(Mack::Paths.mailers)

# Require all mailers
Dir.glob(Mack::Paths.mailers("**/*.rb")).each do |mailer|
  require mailer
end