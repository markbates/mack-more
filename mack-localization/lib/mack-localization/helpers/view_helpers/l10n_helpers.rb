module Mack
  module ViewHelpers # :nodoc:
    module L10NHelpers
      
      class Context
        include Mack::ViewHelpers::L10NHelpers
        
        def initialize(view_sym, lang)
          @view_sym = view_sym
          @lang     = lang
        end
        
        def gets(key)
          l10n_gets(key, @view_sym, @lang)
        end
        
        def getimg(key)
          l10n_getimg(key, @view_sym, @lang)
        end
        
        def date(time, type)
          l10n_date(time, type, @lang)
        end
        
        def number(num)
          l10n_number(num, @lang)
        end
        
        def currency(amount)
          l10n_currency(amount, @lang)
        end
      end
      
      def l10n_context(view_sym, lang = session[:lang] || :en)
        ctx = Context.new(view_sym, lang)
        yield ctx
      end
      
      #
      # View helper method to get the localized string in the given view_sym path and language
      # using the specified key.
      #
      # params:
      #   key - lookup key
      #   view_sym - tell the system where to look for the content file
      #   lang - the language code
      #
      # See:
      #   Mack::Localization::Translator.getimg
      #
      # Returns:
      #   the multibyte version of the localized string
      #
      def l10n_gets(key, view_sym = controller.controller_name, lang = session[:lang] || :en)
        return l10n_translator.gets(view_sym.to_sym, key, lang)
      end
      
      #
      # View helper method to get the localized image path in the given view_sym path and language
      # using the specified key.
      #
      # params:
      #   key - lookup key
      #   view_sym - tell the system where to look for the content file
      #   lang - the language code
      #
      # See:
      #   Mack::Localization::Translator.getimg
      #
      # Returns:
      #   the multibyte version of the path to the localized image
      #
      def l10n_getimg(key, view_sym = controller.controller_name, lang = session[:lang] || :en)
        return l10n_translator.getimg(view_sym.to_sym, key, lang)
      end

      #
      # View helper method to format the specified date based on the given language code
      #
      # params:
      #   time   - the date to be formatted
      #   type   - :short, :medium, :long
      #   lang   - language code
      # 
      # See:
      #   Mack::Localization::Formatter.date_format
      #
      # Example:
      #   aTime = Time.local(2008, "jan", 1)
      #   l10n_date(aTime, :short, :en) produces "Jan 01, 2008"
      #
      # Returns:
      #   the multibyte version of the formatted date
      #
      def l10n_date(time, type, lang = session[:lang] || :en)
        return l10n_formatter.date_format(time, type, lang)
      end
      
      #
      # View helper method to format the number based on the given language code
      #
      # params:
      #   num  - the number to be formatted
      #   lang - language code
      # 
      # See:
      #   Mack::Localization::Formatter.number_format
      #
      # Example:
      #   l10n_number(10000, :en) produces "10,000.00"
      #
      # Returns:
      #   the multibyte version of the formatted number
      #
      def l10n_number(num, lang = session[:lang] || :en)
        return l10n_formatter.number_format(num, lang)
      end
      
      #
      # View helper method to format the currency based on the given language code
      #
      # params:
      #   amount - the amount of money
      #   lang   - language code
      # 
      # See:
      #   Mack::Localization::Formatter.currency_format
      #
      # Example:
      #   l10n_currency(10000, :en) produces "$10,000.00"
      #
      # Returns:
      #   the multibyte version of the formatted currency
      #
      def l10n_currency(amount, lang = session[:lang] || :en)
        return l10n_formatter.currency_format(amount, lang)
      end
      
    end
  end
end
