class NilClass
  
  def to_param
    raise NoMethodError.new(:to_param)
  end
  
end