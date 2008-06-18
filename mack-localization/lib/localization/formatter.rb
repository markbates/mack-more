module Mack
  module Localization
    class Formatter
      
      include Singleton
      
      #
      # Initialize the formatter object.  Out of the box
      # it will register 5 language supports for both
      # the date and currency format
      #
      def initialize
        @reg = Mack::Localization::FormatEngineRegistry.instance

        [:en, :bp, :fr, :it, :de, :es].each do |lang|
          klass = "Mack::Localization::DateFormatEngine::#{lang.to_s.upcase}" 
          @reg.register(lang, date_format_registry_key, klass.constantize.new)
        end
        
        [:en, :bp, :fr, :it, :de, :es].each do |lang|
          klass = "Mack::Localization::NumberAndCurrencyFormatEngine::#{lang.to_s.upcase}" 
          @reg.register(lang, currency_format_registry_key, klass.constantize.new)
        end
      end
      
      #
      # Given a time, format according to the specified type (:short, :medium, :long)
      # and language. 
      #
      # params:
      #   time - the instance of time to be formatted
      #   type - what's the format? short, medium, or long
      #   lang - the language
      # 
      # returns:
      #   the multibyte version of the formatted string
      #
      # see also:
      #   l10n_date in view_helpers
      #
      # examples:
      #   time = Time.local(2008, "dec", 1)
      #   date_format(time, :short, :en) will produce "12/01/2008"
      #   date_format(time, :medium, :en) will produce "Tue, Dec 01, 2008"
      #   date_format(time, :long, :en) will produce "Tuesday, December 01, 2008"
      #
      def date_format(time, type, lang)
        engine = @reg.get_engine(lang, date_format_registry_key)
        raise Mack::Localization::Errors::FormatEngineNotFound.new(lang.to_s) if engine.nil?
        return u(engine.format(time, type))
      end
      
      # 
      # Given a number, format it according to the specified language
      #
      # params:
      #   num - the number to be formatted
      #   lang - the language
      #
      # returns:
      #   the multibyte version of the formatted string
      #
      # see also:
      #   l10n_number in view_helpers
      #
      # examples:
      #   number_format(10000.00, :en) will produce "10,000.00"
      #
      def number_format(num, lang)
        engine = @reg.get_engine(lang, currency_format_registry_key)
        raise Mack::Localization::Errors::FormatEngineNotFound.new(lang.to_s) if engine.nil?
        return u(engine.format_number(num, lang))
      end
      
      # 
      # Given a currency, format it according to the specified language
      #
      # params:
      #   num - the amount of money to be formatted
      #   lang - the language
      #
      # returns:
      #   the multibyte version of the formatted string
      #
      # see also:
      #   l10n_currency in view_helpers
      #
      # examples:
      #   currency_format(10000.00, :en) will produce "$10,000.00"
      #
      def currency_format(num, lang)
        engine = @reg.get_engine(lang, currency_format_registry_key)
        raise Mack::Localization::Errors::FormatEngineNotFound.new(lang.to_s) if engine.nil?
        return u(engine.format_currency(num, lang))
      end
      
      # 
      # Return the registry key for date formatter
      #
      def date_format_registry_key
        return :date_format
      end
      
      #
      # Return the registry key for currency formatter
      #
      def currency_format_registry_key
        return :currency_format
      end
    end
  end
end

class Object
  def l10n_formatter
    Mack::Localization::Formatter.instance
  end
end
