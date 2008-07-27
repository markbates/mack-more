# Generates the necessary files for a basic mailer.
# 
# Example:
#   rake generate:mailer name=welcome_email
# generates the following files:
#   app/mailers/welcome_email.rb
#   app/mailers/templates/welcome_email/text.erb
#   app/mailers/templates/welcome_email/html.erb
#   test/unit/welcome_email_spec.rb # => if using RSpec
#   test/unit/welcome_email_test.rb # => if using Test::Unit::TestCase
class MailerGenerator < Genosaurus
  
  require_param :name
  
  def file_name # :nodoc:
    param(:name).underscore.downcase
  end
  
  def class_name # :nodoc:
    param(:name).camelcase
  end
  
end