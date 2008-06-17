module Mack
  module Localization
    module NumberAndCurrencyFormatEngine
      class EN < Base
        def delimiter
          return ","
        end
        
        def unit
          return "$"
        end
        
        def separator
          return "."
        end
        
      end
    end
  end
end
