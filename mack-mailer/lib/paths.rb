module Mack # :nodoc:
  module Paths
    
    def self.mailers(*args)
      File.join(Mack.root, "app", "mailers", args)
    end
    
  end
end