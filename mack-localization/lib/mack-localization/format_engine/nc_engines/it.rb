module Mack
  module Localization # :nodoc:
    module NumberAndCurrencyFormatEngine # :nodoc:
      class IT < Base
        def delimiter
          return "."
        end
        
        def unit
          return "€"
        end
        
        def separator
          return ","
        end
        
      end
    end
  end
end
