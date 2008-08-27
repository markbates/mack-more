module Mack
  module DataMapper # :nodoc:
    
    # Used to store the Mack::Session object in the db.
    class Session
      include ::DataMapper::Resource
      
      property :id, String, :key => true
      property :data, Yaml, :nullable => false, :lazy => false
      property :updated_at, DateTime
    end # Session
    
  end # DataMapper
end # Mack