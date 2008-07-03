# This will generate a migration for your application.
# 
# Example without columns:
#   rake generate:migration name=create_users
# 
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
#   rake generate:migration name=create_users cols=username:string,email_address:string,created_at:date_time,updated_at:date_time
# 
# db/migrations/<number>_create_users.rb:
#   migration <number>, :create_users do
#     up do
#       create_table :users do
#         column :id, Integer, :serial => true
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
class MigrationGenerator < Genosaurus

  require_param :name
  
  def setup
    @table_name = param(:name).underscore.gsub("create_", "")
    @current_migration_number = next_migration_number
    @migration_name = "#{@current_migration_number}_#{param(:name).underscore}"
  end
  
  def migration_columns
    [Mack::Genosaurus::ModelColumn.new(param(:name), "id:serial"), columns].flatten
  end
  
  def get_column_type(column)
    column.column_type.camelcase
  end
  
end