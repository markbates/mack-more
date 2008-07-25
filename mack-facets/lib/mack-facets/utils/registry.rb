require 'singleton'
module Mack
  module Utils
    # This is a general purpose Singleton Registry class.
    # It takes the drudgery out of creating registry classes, that
    # are, let's face it, all pretty much the same.
    class Registry
      include Singleton
      include Extlib::Hook
      
      # The list of registered items
      attr_reader :registered_items
      
      def initialize # :nodoc:
        reset!
      end
      
      # Override this method to set the initial state of the registered_items Array.
      # By default this list is empty.
      def initial_state
        []
      end
      
      # Resets the registered_items list to the list specified by the initial_state method.
      def reset!
        @registered_items = self.initial_state.dup
      end
      
      # Adds an object to the list at a specified position. By default the position is last.
      def add(klass, position = self.registered_items.size)
        self.registered_items.insert(position, klass)
        self.registered_items.uniq!
        self.registered_items.compact!
      end
      
      # Removes an object from the list.
      def remove(klass)
        self.registered_items.delete(klass)
      end
      
      class << self
        
        # Returns the list of registered items.
        def registered_items
          self.instance.registered_items
        end
        
        # Emptys out the list of registered_items.
        def clear!
          registered_items.clear
        end
        
        # Resets the registered_items list to the list specified by the initial_state method.
        def reset!
          self.instance.reset!
        end
        
        # Adds an object to the list at a specified position. By default the position is last.
        def add(klass, position = registered_items.size)
          self.instance.add(klass, position)
        end
        
        # Removes an object from the list.
        def remove(klass)
          self.instance.remove(klass)
        end
        
        # Moves an object to the top of the registered_items list.
        def move_to_top(klass)
          self.instance.add(klass, 0)
        end
        
        # Moves an object to the bottom of the registered_items list.
        def move_to_bottom(klass)
          remove(klass)
          self.instance.add(klass)
        end
        
      end
      
    end # Registry
  end # Utils
end # Mack