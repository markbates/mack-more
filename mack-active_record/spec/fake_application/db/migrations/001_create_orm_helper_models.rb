class CreateOrmHelpersModels < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string
    end
    create_table :people do |t|
      t.column :full_name, :string
    end
  end
  def self.down
    drop_table :users
    drop_table :people
  end
end