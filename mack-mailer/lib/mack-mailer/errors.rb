module Mack
  module Errors # :nodoc:
    
    class UnconvertedMailer < StandardError
      def initialize # :nodoc:
        super("You must convert the Mack::Mailer object first!")
      end
    end # UnconvertedMailer
    
  end # Errors
end # Mack