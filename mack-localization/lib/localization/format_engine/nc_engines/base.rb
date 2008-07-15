module Mack
  module Localization # :nodoc:
    module NumberAndCurrencyFormatEngine # :nodoc:
      class Base
        
        def format_currency(num, lang)
          currency = "#{unit}#{format_number(num, lang)}"
          return currency
        end

        def format_number(num, lang)
          num_str = "%01.2f" % num
          parts = num_str.split(".")
          parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
          parts.join separator
        end
        
        protected 
        
        def delimiter
          raise "Unimplemented: delimiter"
        end
        
        def unit
          raise "Unimplemented: unit"
        end
        
        def separator
          raise "Unimplemented: separator"
        end
        
      end
    end
  end
end
