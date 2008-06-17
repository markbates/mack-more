class Class
  
  # Returns a new Object instance of the class name specified.
  # 
  # Examples:
  #   Class.new_instance_of("Orange") => #<Orange:0x376c0c>
  #   Class.new_instance_of("Animals::Dog") => #<Animals::Dog:0x376a2c>
  def self.new_instance_of(klass_name)
    klass_name.constantize.new
  end
  
  # This will through the ancestor tree of object and tell you if
  # that object is of the specified type.
  def class_is_a?(klass_name)
    self.ancestors.each do |an|
      if an == klass_name
        return true
      end
    end
    return false
  end
  
  # Returns an array of the classes parent classes.
  # 
  # Examples:
  #   Orange.parents # => [Citrus, Fruit, Object]
  #   Citrus.parents # => [Fruit, Object]
  #   Fruit.parents # => [Object]
  def parents
    ans = [self.superclass]
    until ans.last.superclass.nil?
      ans << ans.last.superclass
    end
    ans
  end
  
end
  