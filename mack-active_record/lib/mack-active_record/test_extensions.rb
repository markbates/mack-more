if Mack.env == "test"
  module Mack
    module Testing # :nodoc: 
    end
  end

  # Wrap it so we don't accidentally alias the run method n times and run out of db connections!
  unless Mack::Testing.const_defined?("AR_TEST_EXTENSIONS")
    
    module Mack
      module Testing
        AR_TEST_EXTENSIONS = 1
        
        def rollback_transaction
          begin
            ActiveRecord::Base.transaction do
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