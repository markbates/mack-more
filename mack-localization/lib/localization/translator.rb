module Mack
  module Localization
    class Translator
      include Singleton
      
      #
      # Get the localized string for the specified language using the given key in the view_sym namespace.
      # The view symbol is how the system knows where to locate the content file.
      # By default the localization of the file is in [app_directory]/lang/views/[view_sym]/content_[lang].yml
      # 
      # params:
      #    view_sym -- which view is the key located in?
      #    key -- the lookup key
      #    lang -- the language
      #
      # returns:
      #    the multibyte version of the string
      #
      # raise:
      #    UnsupportedLanguage if the specified language is not defined in the 'supported_languages' array
      #    UnknownStringKey if the key specified is not defined in the content file
      #
      # see also:
      #    l10n_gets in view_helpers
      #
      def gets(view_sym, key, lang)
        view_name = view_sym.to_s
        base_lang = l10n_config.base_language
        base_lang = lang.to_s if !lang.nil?
        
        raise Mack::Localization::Errors::UnsupportedLanguage.new(base_lang) if !l10n_config.supported_languages.include?(base_lang)
        
        cache_key = "#{view_sym}_#{base_lang}_content"
        path      = File.join(l10n_config.base_directory, "views", "#{view_name}", "content_#{base_lang}.yml")
        content_hash = load_content_hash(cache_key, base_lang, path)
      
        raise Mack::Localization::Errors::UnknownStringKey.new(key) if content_hash[key] == nil
        return u(content_hash[key])
      end
      
      def getimg(view_sym, key, lang)
        raise Mack::Localization::Errors::UnsupportedFeature.new("getimg")
      end
      
      # REVIEW: inflection... should localized inflection use the same inflection engine as the english counterpart?
      def pluralize(key, lang, num)
        return u(inflect(key, lang, num, :plural))
      end
      
      def irregular(key, lang, num)
        return u(inflect(key, lang, num, :irregular))
      end
    
      private
      
      def inflect(key, lang, num, type)
        base_lang = l10n_config.base_language
        base_lang = lang if !lang.nil?
        
        raise Mack::Localization::Errors::UnsupportedLanguage.new(base_lang) if !l10n_config.supported_languages.include?(base_lang)
        
        cache_key = "rules_content_#{base_lang}"
        path      = File.join(l10n_config.base_directory, "rules", "inflection_#{base_lang}.yml")
        content_hash = load_content_hash(cache_key, base_lang, path)
        
        hash = content_hash[type]
        raise Mack::Localization::Errors::InvalidConfiguration.new if hash.nil?
        
        arr = hash[key]
        raise Mack::Localization::Errors::InvalidConfiguration.new if arr.nil?
        raise Mack::Localization::Errors::InvalidConfiguration.new if arr.size != 2
        
        if num <= 1
          val = sprintf(arr[0], num)
        else
          val = sprintf(arr[1], num)
        end
        
        return val
      end
            
      private 
      
      def load_content_hash(cache_key, base_lang, path)
        # content_hash = l10n_config.send("#{cache_key}")
        content_hash = l10n_cache.get("#{cache_key}")
        
        if content_hash.nil?
          raise Mack::Localization::Errors::InvalidConfiguration.new if base_lang.nil?
          raise Mack::Localization::Errors::LanguageFileNotFound.new if !File.exists?(path)
          
          data = File.read(path)
          content_hash = YAML.load(data)
          l10n_cache.set("#{cache_key}", content_hash, l10n_config.content_expiry)
        end
        
        return content_hash
      end
      
    end
  end
end

class Object
  def l10n_translator
    Mack::Localization::Translator.instance
  end
end