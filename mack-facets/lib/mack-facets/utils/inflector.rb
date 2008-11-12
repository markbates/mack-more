require 'singleton'
require File.join(File.dirname(__FILE__), "..", "english_extensions", 'inflect')
module Mack # :nodoc:
  module Utils # :nodoc:
    # This class is used to deal with inflection strings. This means taken a string and make it plural, or singular, etc...
    # Inflectionion rules can be added very easy, and are checked from the bottom up. This means that the last rule is the first
    # rule to be matched. The exception to this, kind of, is 'irregular' and 'uncountable' rules. The 'uncountable' rules are
    # always checked first, then the 'irregular' rules, and finally either the 'singular' or 'plural' rules, depending on what
    # you're trying to do. Within each of these sets of rules, the last rule in is the first rule matched.
    # 
    # Example:
    #   Mack::Utils::Inflectionor.inflections do |inflect|
    #     inflect.plural(/$/, 's')
    #     inflect.plural(/^(ox)$/i, '\1en')
    #     inflect.plural(/(phenomen|criteri)on$/i, '\1a')
    #   
    #     inflect.singular(/s$/i, '')
    #     inflect.singular(/(n)ews$/i, '\1ews')
    #     inflect.singular(/^(.*)ookies$/, '\1ookie')
    #   
    #     inflect.irregular('person', 'people')
    #     inflect.irregular('child', 'children')
    #   end
    class Inflector
      include Singleton
      
      # Adds a plural rule to the system.
      # 
      # Example:
      #   Mack::Utils::Inflectionor.inflections do |inflect|
      #     inflect.plural(/$/, 's')
      #     inflect.plural(/^(ox)$/i, '\1en')
      #     inflect.plural(/(phenomen|criteri)on$/i, '\1a')
      #   end
      def plural(rule, replacement)
        Extlib::Inflection.plural_rule(rule, replacement)
      end
      
      # Adds a singular rule to the system.
      # 
      # Example:
      #   Mack::Utils::Inflectionor.inflections do |inflect|
      #     inflect.singular(/s$/i, '')
      #     inflect.singular(/(n)ews$/i, '\1ews')
      #     inflect.singular(/^(.*)ookies$/, '\1ookie')
      #   end
      def singular(rule, replacement)
        Extlib::Inflection.singular_rule(rule, replacement)
      end
      
      # Adds a irregular rule to the system.
      # 
      # Example:
      #   Mack::Utils::Inflectionor.inflections do |inflect|
      #     inflect.irregular('person', 'people')
      #     inflect.irregular('child', 'children')
      #   end
      def irregular(rule, replacement)
        Extlib::Inflection.rule(rule, replacement)
        Extlib::Inflection.word(rule, replacement)
      end
      
      # Returns the singular version of the word, if possible.
      # 
      # Examples:
      #   Mack::Utils::Inflectionor.instance.singularize("armies") # => "army"
      #   Mack::Utils::Inflectionor.instance.singularize("people") # => "person"
      #   Mack::Utils::Inflectionor.instance.singularize("boats") # => "boat"
      def singularize(word)
        Extlib::Inflection.singular(word)
      end
      
      # Returns the singular version of the word, if possible.
      # 
      # Examples:
      #   Mack::Utils::Inflectionor.instance.pluralize("army") # => "armies"
      #   Mack::Utils::Inflectionor.instance.pluralize("person") # => "people"
      #   Mack::Utils::Inflectionor.instance.pluralize("boat") # => "boats"
      def pluralize(word)
        Extlib::Inflection.plural(word)
      end
      
      public
      class << self
        
        # Yields up Mack::Utils::Inflectionor.instance
        def inflections
          if block_given?
            yield Mack::Utils::Inflector.instance
          else
            Mack::Utils::Inflector.instance
          end
        end
        
      end
      
    end # Inflectionion
  end # Utils
end # Mack