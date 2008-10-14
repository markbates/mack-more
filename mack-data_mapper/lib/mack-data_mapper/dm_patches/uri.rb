module DataObjects # :nodoc:
  class URI # :nodoc:
    
    def basename
      self.path[1..self.path.length]
    end
    
  end # URI
end # DataObjects