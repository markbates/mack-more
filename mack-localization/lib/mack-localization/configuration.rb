
#
# Mack Localization's main configuration.
# When loaded it will try to load localization.yml file from
# {config_dir}/localization/ inside the application directory.
# If the file doesn't exist then it will just load default configuration.
#
module Mack
  module Localization # :nodoc:
    module Configuration

      configatron.mack.localization.base_language = 'en'
      configatron.mack.localization.supported_languages = %w{bp en fr it de es}
      configatron.mack.localization.char_encoding = 'us-ascii'
      configatron.mack.localization.dynamic_translation = false
      configatron.mack.localization.base_directory = Mack::Paths.app('lang')
      configatron.mack.localization.content_expiry = 3600
      
      path = Mack::Paths.config("localization", "localization.rb")
      if File.exists?(path)
        require path
      end
    end 
  end
end

class Object  
  
  #
  # Give access to the mack l10n config object from anywhere inside the application
  #
  def l10n_config
    configatron.mack.localization
  end
end