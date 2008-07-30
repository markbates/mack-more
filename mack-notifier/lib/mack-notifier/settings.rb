if app_config.notifier.nil? || app_config.notifier.smtp_settings.nil?
  app_config.load_file(File.join(File.dirname(__FILE__), "configs", "smtp_settings.yml"))
end

if app_config.notifier.nil? || app_config.notifier.sendmail_settings.nil?
  app_config.load_file(File.join(File.dirname(__FILE__), "configs", "sendmail_settings.yml"))
end

if app_config.notifier.nil? || app_config.notifier.deliver_with.nil?
  app_config.load_hash({"notifier::deliver_with" => (Mack.env == "test" ? "test" : "smtp")}, String.randomize)
end

if app_config.notifier.nil? || app_config.notifier.adapter.nil?
  app_config.load_hash({"notifier::adapter" => "tmail"}, String.randomize)
end