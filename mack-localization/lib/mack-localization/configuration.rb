
#
# Mack Localization's main configuration.
# When loaded it will try to load localization.yml file from
# {config_dir}/localization/ inside the application directory.
# If the file doesn't exist then it will just load default configuration.
#
module Mack
  module Localization # :nodoc:
    module Configuration

      configatron do |c|
        c.namespace(:mack) do |mack|
          mack.namespace(:localization) do |l|
            l.base_language = 'en'
            l.supported_languages = %w{bp en fr it de es}
            l.char_encoding = 'us-ascii'
            l.dynamic_translation = false
            l.base_directory = Mack::Paths.app('lang')
            l.content_expiry = 3600
          end
        end
      end
      
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