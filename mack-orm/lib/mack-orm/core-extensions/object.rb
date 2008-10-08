class Object
  
  def error_for(meth_name)
    if self.respond_to?("errors") and self.errors
      return self.errors[meth_name.to_sym]
    end
  end
  
end