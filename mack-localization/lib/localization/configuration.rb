
#
# Mack Localization's main configuration.
# When loaded it will try to load localization.yml file from
# {config_dir}/localization/ inside the application directory.
# If the file doesn't exist then it will just load default configuration.
#
module Mack
  module Localization
    module Configuration

      unless self.const_defined?("L10N_DEFAULTS")
        L10N_DEFAULTS = {
          "base_language"       => "en",
          "supported_languages"  => %w{bp en fr it de es},
          "char_encoding"       => 'us-ascii',
          "dynamic_translation" => false,
          "base_directory"      => File.join(Mack::Configuration.app_directory, "lang"),
          "content_expiry"      => 3600
        }
      end
      
      app_config.load_hash(L10N_DEFAULTS, "l10n_defaults")
      path = File.join(Mack::Configuration.config_directory, "localization", "localization.yml")
      if File.exists?(path)
        app_config.load_file(path)
      end
    end 
  end
end

class Object  
  
  #
  # Give access to the mack l10n config object from anywhere inside the application
  #
  def l10n_config
    app_config
  end
end