# This will generate an ORM 'model' for your application based on the specified ORM you're using. 
# 
# Example without columns:
#   rake generate:model name=user
# 
# app/models/user.rb:
#   class User
#     include DataMapper::Resource
#     
#   end
# db/migrations/<number>_create_users.rb:
#   migration <number>, :create_users do
#     up do
#     end
#   
#     down do
#     end
#   end
# 
# Example with columns:
#   rake generate:model name=user cols=username:string,email_address:string,created_at:datetime,updated_at:datetime
# 
# app/models/user.rb:
#   class User
#     include DataMapper::Resource
# 
#     property :username, String
#     property :email_address, String
#     property :created_at, DateTime
#     property :updated_at, DateTime
#   end
# db/migrations/<number>_create_users.rb:
#   migration <number>, :create_users do
#     up do
#       create_table :users do
#         column :username, String, :size => 50
#         column :email, String, :size => 50
#         column :created_at, DateTime
#         column :updated_at, DateTime
#       end
#     end
#   
#     down do
#       drop_table :users
#     end
#   end
class ModelGenerator < Genosaurus
  
  require_param :name

  def after_generate # :nodoc:
    MigrationGenerator.run(@options.merge({"name" => "create_#{param(:name).plural}"}))
  end
  
  def migration_columns # :nodoc:
    [Mack::Genosaurus::DataMapper::ModelColumn.new(param(:name), "id:serial"), columns].flatten
  end
  
end