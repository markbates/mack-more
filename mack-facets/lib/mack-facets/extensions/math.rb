module Math

  def self.log2(x)
     self.log(x)/self.log(2.0)
  end

  def self.min(a, b)
     a < b ? a : b
  end

  def self.max(a, b)
     a > b ? a : b
  end

end