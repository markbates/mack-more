class MailerGenerator < Genosaurus
  
  require_param :name
  
  def file_name
    param(:name).underscore.downcase
  end
  
  def class_name
    param(:name).camelcase
  end
  
end