require File.join(File.dirname(__FILE__), "base")
module Mack
  module Mailer
    module Adapters # :nodoc:
      class Tmail < Mack::Mailer::Adapters::Base
        
        def to_s
          
        end
        
        def transformed
          raise Mack::Errors::UnconvertedMailer.new
          @tmail
        end
        
        def convert
          
        end
        
      end # Tmail
    end # Adapters
  end # Mailer
end # Mack