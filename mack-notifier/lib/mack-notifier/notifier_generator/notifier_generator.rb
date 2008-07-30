# Generates the necessary files for a basic notifier.
# 
# Example:
#   rake generate:notifier name=welcome_email
# generates the following files:
#   app/notifiers/welcome_email.rb
#   app/notifiers/templates/welcome_email/text.erb
#   app/notifiers/templates/welcome_email/html.erb
#   test/unit/welcome_email_spec.rb # => if using RSpec
#   test/unit/welcome_email_test.rb # => if using Test::Unit::TestCase
class NotifierGenerator < Genosaurus
  
  require_param :name
  
  def file_name # :nodoc:
    param(:name).underscore.downcase
  end
  
  def class_name # :nodoc:
    param(:name).camelcase
  end
  
end