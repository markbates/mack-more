require 'date'
require 'time'

module Mack
  module Facets
    module DateTime
      def add_seconds(secs)
        # self + (secs / 1.day.to_i)
        self.since(secs)
      end

      # Subtracts seconds and returns a new DateTime object
      def minus_seconds(secs)
        # self - (secs / 1.day.to_i)
        self.ago(secs)
      end
      
    end
  end
end

DateTime.send(:include, Mack::Facets::DateTime)