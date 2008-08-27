class DateTime
  
  # Adds seconds and returns a new DateTime object
  def add_seconds(secs)
    self + (secs.to_f / 1.day)
  end
  
  # Subtracts seconds and returns a new DateTime object
  def minus_seconds(secs)
    self - (secs.to_f / 1.day)
  end
  
end