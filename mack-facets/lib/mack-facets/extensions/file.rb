class File
  
  alias_class_method :join
  
  class << self
    
    # Join now works like it should! It calls .to_s on each of the args
    # pass in. It handles nested Arrays, etc...
    def join(*args)
      fs = [args].flatten
      _original_join(fs.collect{|c| c.to_s})
    end
    
    def join_from_here(*args)
      caller.first.match(/(.+):.+/)
      File.expand_path(File.join(File.dirname($1), *args))
    end
    
  end
  
end