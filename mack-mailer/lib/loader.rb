# If the mailers directory does not exist, create it.
FileUtils.mkdir_p(Mack::Paths.mailers)

# Require all mailers
Dir.glob(Mack::Paths.mailers("**/*.rb")).each do |mailer|
  puts mailer
  require mailer
end

if app_config.mailer.nil? || app_config.mailer.smtp_settings.nil?
  app_config.load_file(File.join(File.dirname(__FILE__), "configs", "smtp_settings.yml"))
end

if app_config.mailer.nil? || app_config.mailer.sendmail_settings.nil?
  app_config.load_file(File.join(File.dirname(__FILE__), "configs", "sendmail_settings.yml"))
end

if app_config.mailer.nil? || app_config.mailer.deliver_with.nil?
  app_config.load_hash({"mailer::deliver_with" => (Mack.env == "test" ? "test" : "smtp")}, String.randomize)
end