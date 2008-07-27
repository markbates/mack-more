module Mack
  module Localization # :nodoc:
    module NumberAndCurrencyFormatEngine # :nodoc:
      class BP < Base
        def delimiter
          return ","
        end
        
        def unit
          return "R$"
        end
        
        def separator
          return "."
        end
        
      end
    end
  end
end
