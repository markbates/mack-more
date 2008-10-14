require "test/unit"
require 'spec'

if Mack.env == "test"
  module Mack
    module Testing # :nodoc: 
    end
  end

  # Wrap it so we don't accidentally alias the run method n times and run out of db connections!
  unless Mack::Testing.const_defined?("DmTestTransactionWrapper")
  
    module Mack
      module Testing
      
        class DmTestTransactionWrapper # :nodoc:
          include DataMapper::Resource
          
          property :id, Serial
        end
        Mack::Database.establish_connection
        DmTestTransactionWrapper.auto_migrate!
      
        def rollback_transaction
          begin
            puts 'about to start transaction'
            Mack::Testing::DmTestTransactionWrapper.transaction do
              puts 'in transaction'
            # DataMapper::Transaction.new.commit do
              yield if block_given?
              raise "Rollback!"
            end
          rescue => ex
            # we need to do this so we can throw up actual errors!
            unless ex.to_s == "Rollback!"
              raise ex
            end
          end
        end # rollback_transaction

      end # Testing
    end # Mack
  
  end
  
end