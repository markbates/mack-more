class Object
  
  def has_error?(meth_name)
    if self.respond_to?("errors") and self.errors
      arr = self.errors[meth_name.to_sym]
      return !arr.nil? and !arr.empty?
    end
  end
  
  def error_for(meth_name)
    if self.respond_to?("errors") and self.errors
      return self.errors[meth_name.to_sym]
    end
  end
  
end