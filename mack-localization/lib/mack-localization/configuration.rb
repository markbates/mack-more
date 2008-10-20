
#
# Mack Localization's main configuration.
# When loaded it will try to load localization.yml file from
# {config_dir}/localization/ inside the application directory.
# If the file doesn't exist then it will just load default configuration.
#

module Mack
  module Localization
    
    class Configuration
      include Singleton
      def initialize
        @storage = Mack::Localization::Storage.new
      end
      
      def setup
        yield @storage
      end
      
      def method_missing(sym, *args)
        @storage.send(sym, *args)
      end
    end
    
    class Storage
      
      def base_directory= (path)
        arr = configatron.mack.localization.base_directory
        arr = [] if arr.is_a?(Configatron::Store) and !arr.is_a?(Array)
        arr << path
        arr.uniq!
        configatron.mack.localization.base_directory = arr
      end
      
      def base_directory
        arr = configatron.mack.localization.base_directory
        arr = [Mack::Paths.app('lang')] if arr.is_a?(Configatron::Store) and !arr.is_a?(Array)
        return (arr.size == 1) ? arr[0] : arr
      end
      
      def method_missing(sym, *args)
        supported_settings = [:base_language, :supported_languages, :char_encoding, :dynamic_translation, :content_expiry,
                              :base_language=, :supported_languages=, :char_encoding=, :dynamic_translation=, :content_expiry=]
        if supported_settings.include?(sym)
          configatron.mack.localization.send(sym, *args)
        end
      end
    end
  end
end

class Object  
  
  #
  # Give access to the mack l10n config object from anywhere inside the application
  #
  def l10n_config
    Mack::Localization::Configuration.instance
  end
end
