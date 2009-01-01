# This class is only here because active_support 2.2.2 requires test/unit/error,
# and apparently that does not exist in Ruby 1.9. This, should hopefully, go away
# in a future version of active_support.
module Test # :nodoc:
  module Unit # :nodoc:

    class Error # :nodoc:
      
      def message(*args)
        Mack.logger.error(args.inspect)
      end
      
    end
  end
end