module Mack
  module Localization
    module NumberAndCurrencyFormatEngine
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
