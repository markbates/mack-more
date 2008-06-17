class Array
  
  # This method is useful when you have a method that looks like this:
  # def foo(*args)
  #   do something
  # end
  # The problem is when you use the * like that everything that comes in is
  # an array. Here are a few problems with this:
  # foo([1,2,3])
  # When you pass an array into this type of method you get the following nested array:
  # [[1,2,3]]
  # The parse_splat_args method, if called, would do this:
  # args.parse_splat_args # => [1,2,3]
  # Now say you called this method like such:
  # foo(1)
  # args would be [1]
  # args.parse_splat_args # => 1
  # Finally
  # foo
  # args.parse_splat_args # => nil
  def parse_splat_args
    unless self.empty?
      args = self#.flatten
      case args.size
      when 1
        return args.first # if there was only one arg passed, return just that, without the array
      when 0
        return nil # if no args were passed return nil
      else
        return args # else return the array back, cause chances are that's what they passed you!
      end
    end
  end
  
  # This will return a new instance of the array sorted randomly.
  def randomize(&block)
    if block_given?
      self.sort {|x,y| yield x, y}
    else
      self.sort_by { rand }
    end
  end
  
  # This calls the randomize method, but will permantly replace the existing array.
  def randomize!(&block)
    if block_given?
      self.replace(self.randomize(&block))
    else
      self.replace(self.randomize)
    end
  end
  
  # This will pick a random value from the array
  def pick_random
    self[rand(self.length)]
  end
  
  # This allows you to easily recurse of the array randomly.
  def random_each
    self.randomize.each {|x| yield x}
  end
  
  def subset?(other)
    self.each do |x|
      return false if !(other.include? x)
    end
    true
  end
  
  def superset?(other)
    other.subset?(self)
  end
  
  # This will give you a count, as a Hash, of all the values in the Array.
  # %w{spam spam eggs ham eggs spam}.count # => {"eggs" => 2, "ham" => 1, "spam" => 3}
  def count
    k = Hash.new(0)
    self.each{|x| k[x] += 1}
    k
  end
  
  # This will invert the index and the values and return a Hash of the results.
  # %w{red yellow orange}.invert # => {"red" => 0, "orange" => 2, "yellow" => 1}
  def invert
    h = {}
    self.each_with_index{|x,i| h[x] = i}
    h
  end
  
end
