module Mack
  module ViewHelpers
    module StringHelpers
      
      # Escapes Javascript
      #
      def escape_javascript(javascript)
        (javascript || '').gsub('\\','\0\0').gsub('</','<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
      end
      
    end
  end
end
