class Person
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :full_name, String
  
  validates_present :full_name
end