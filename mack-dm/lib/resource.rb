module DataMapper
  module Resource
    
    def to_param
      self.key
    end
    
  end
end