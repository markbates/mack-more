require 'singleton'
module Mack
  module Utils

    #
    # Provides a convenient way to register items in a map.
    #
    # ds - july 2008
    #
    class RegistryMap
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
        {}
      end
      
      # Resets the registered_items list to the list specified by the initial_state method.
      def reset!
        @registered_items = self.initial_state.dup
      end
      
      # Adds an object to the list at a specified position. By default the position is last.
      def add(tag, klass, position = -1)
        @registered_items[tag] ||= []
        arr = self.registered_items[tag]
        position = arr.size if position == -1
        
        arr.insert(position, klass)
        arr.uniq!
        arr.compact!
      end
      
      # Removes an object from the list.
      def remove(tag, klass)
        return false if @registered_items[tag] == nil
        self.registered_items[tag].delete(klass)
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
        def add(tag, klass, position = -1)
          self.instance.add(tag, klass, position)
        end
        
        # Removes an object from the list.
        def remove(tag, klass)
          self.instance.remove(tag, klass)
        end
        
        # Moves an object to the top of the registered_items list.
        def move_to_top(tag, klass)
          self.instance.add(tag, klass, 0)
        end
        
        # Moves an object to the bottom of the registered_items list.
        def move_to_bottom(tag, klass)
          remove(tag, klass)
          self.instance.add(tag, klass)
        end
        
      end
      
    end # RegistryMap
  end # Utils
end # Mack