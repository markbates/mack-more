if app_config.mailer.nil? || app_config.mailer.smtp_settings.nil?
  app_config.load_file(File.join(File.dirname(__FILE__), "configs", "smtp_settings.yml"))
end

if app_config.mailer.nil? || app_config.mailer.sendmail_settings.nil?
  app_config.load_file(File.join(File.dirname(__FILE__), "configs", "sendmail_settings.yml"))
end

if app_config.mailer.nil? || app_config.mailer.deliver_with.nil?
  app_config.load_hash({"mailer::deliver_with" => (Mack.env == "test" ? "test" : "smtp")}, String.randomize)
end

if app_config.mailer.nil? || app_config.mailer.adapter.nil?
  app_config.load_hash({"mailer::adapter" => "tmail"}, String.randomize)
end