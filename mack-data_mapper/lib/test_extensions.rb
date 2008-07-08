# require "test/unit"
# 
# module Mack
#   module Testing
#   end
# end
# 
# # Wrap it so we don't accidentally alias the run method n times and run out of db connections!
# unless Mack::Testing.const_defined?("DmTestTransactionWrapper")
# 
#   class Mack::Testing::DmTestTransactionWrapper
#     include DataMapper::Resource
#   end
# 
#   def rollback_transaction(&block)
#     begin
#       Mack::Testing::DmTestTransactionWrapper.transaction do
#         puts "block_given?: #{block_given?}"
#         yield if block_given?
#         raise "Rollback!"
#       end
#     rescue => ex
#       puts ex
#       # we need to do this so we can throw up actual errors!
#       unless ex.to_s == "Rollback!"
#         raise ex
#       end
#     end
#   end
# 
#   module Spec
#     module Example
#       module ExampleGroupMethods
#         alias_method :rspec_it, :it
#         
#          def it(description = nil, &implementation)
#            rspec_it(description) do
#              puts "-------"
#              # rollback_transaction(&implementation)
#              puts "*******"
#            end
#          end
# 
#       end
#     end
#   end
#   
#   module Test
#     module Unit # :nodoc:
#       class TestCase # :nodoc:
#   
#         # Let's alias the run method in the class above us so we can create a new one here
#         # but still reference it.
#         alias_method :super_duper_run, :run # :nodoc:
#   
#         # We need to wrap the run method so we can do things like
#         # run a cleanup method if it exists
#         def run(result, &progress_block) # :nodoc:
#           rollback_transaction do
#             super_duper_run(result, &progress_block)
#           end
#         end
#   
#       end # TestCase
#     end # Unit
#   end # Test
#   
# end