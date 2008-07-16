module English # :nodoc:

  # = English Nouns Number Inflection.
  #
  # This module provides english singular <-> plural noun inflections.
  module Inflect # :nodoc:

    class << self

      # Convert an English word from plurel to singular.
      #
      #   "boys".singular      #=> boy
      #   "tomatoes".singular  #=> tomato
      #
      def singular(word)
        if result = singular_of[word]
          return result.dup
        end
        result = word.dup
        singularization_rules.each do |(match, replacement)|
          break if result.gsub!(match, replacement)
        end
        # Mack: cache the result of the translation:
        singular_of[word] = result unless word == result
        return result
      end
      
      # Convert an English word from singular to plurel.
      #
      #   "boy".plural     #=> boys
      #   "tomato".plural  #=> tomatoes
      #
      def plural(word)
        if result = plural_of[word]
          return result.dup
        end
        #return self.dup if /s$/ =~ self # ???
        result = word.dup
        pluralization_rules.each do |(match, replacement)|
          break if result.gsub!(match, replacement)
        end
        # Mack: cache the result of the translation:
        plural_of[word] = result unless word == result
        return result
      end

    end

  end
end