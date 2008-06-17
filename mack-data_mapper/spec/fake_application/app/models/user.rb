class User
  include DataMapper::Resource
  
  property :id, Integer, :serial => true
  property :username, String
  
  validates_present :username
end