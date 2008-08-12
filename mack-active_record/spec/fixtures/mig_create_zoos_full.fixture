class CreateZoos < ActiveRecord::Migration

  def self.up
    create_table :zoos do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :created_at, :date_time
      t.column :updated_at, :date_time
    end
  end

  def self.down
    drop_table :zoos
  end

end
