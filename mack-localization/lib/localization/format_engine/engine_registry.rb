module Mack
  module Localization # :nodoc:
    class FormatEngineRegistry
      include Singleton
      
      def initialize
        # { 
        #    :en => {:date => {...}, :num_currency => {...}},
        #    :fr => ...
        # }
        @reg = {}
      end
      
      #
      # Register a format engine
      #
      # params:
      #   lang - the language of the engine
      #   type - either l10n_formatter.date_format_registry_key or l10n_formatter.currency_format_registry_key
      #   overwrite - whether or not to overwrite the formatter if it's already registered. default == false
      #
      def register(lang, type, obj, overwrite = false)
        lang = lang.to_sym
        type = type.to_sym
        if @reg[lang].nil?
          @reg[lang] = {type => obj}
        else
          type_reg = @reg[lang]
          type_reg[type] = obj if type_reg[type].nil? or (overwrite and !type_reg[type].nil?)
        end
      end
      
      #
      # Retrieve a registered engine
      #
      # params:
      #   lang - the language
      #   type - either l10n_formatter.date_format_registry_key or l10n_formatter.currency_format_registry_key
      #
      # returns the registered engine, or nil if no engine is registered for that type/lang
      #
      def get_engine(lang, type)
        lang = lang.to_sym
        type = type.to_sym
        type_reg = @reg[lang]
        return nil if type_reg.nil?
        return type_reg[type]
      end
      
    end
  end
end
