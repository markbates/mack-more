module DataMapper
  module Resource
    
    # Returns the key of the DataMapper::Resource object when passed into a url helper
    # 
    # Example:
    #   class User
    #     include DataMapper::Resource
    #     property :name, String, :key => true
    #   end
    #   users_show_url(User.new(:username => "markbates")) # => /users/markbates
    def to_param
      self.key
    end
    
  end
end