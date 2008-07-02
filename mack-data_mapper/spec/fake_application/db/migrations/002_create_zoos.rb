migration 2, :create_zoos do

  up do
    create_table :zoos do
      column :id, Serial
      column :name, String
      column :description, DataMapper::Types::Text
      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :zoos
  end

end
