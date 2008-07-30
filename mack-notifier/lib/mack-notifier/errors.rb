module Mack
  module Errors # :nodoc:
    
    class UnconvertedNotifier < StandardError
      def initialize # :nodoc:
        super("You must convert the Mack::Notifier object first!")
      end
    end # UnconvertedNotifier
    
  end # Errors
end # Mack