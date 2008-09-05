# class DateTime
#   
#   # Adds seconds and returns a new DateTime object
#   def add_seconds(secs)
#     self + (secs.to_f / 1.day)
#   end
#   
#   # Subtracts seconds and returns a new DateTime object
#   def minus_seconds(secs)
#     self - (secs.to_f / 1.day)
#   end
#   
# end
require 'date'
require 'time'
DateTime.instance_eval do
  # Adds seconds and returns a new DateTime object

end

module Mack
  module Facets
    module DateTime
      def add_seconds(secs)
        self + (secs.to_f / 1.day)
      end

      # Subtracts seconds and returns a new DateTime object
      def minus_seconds(secs)
        self - (secs.to_f / 1.day)
      end
    end
  end
end

DateTime.send(:include, Mack::Facets::DateTime)