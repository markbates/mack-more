class String
  
  alias_instance_method :snakecase, :underscore
  
  def /(other)
    File.join(self, other.to_s)
  end
  
  if v1_9?
    def each(&block)
      self.each_line(&block)
    end
  end
  
  def methodize
    x = self
    
    # if we get down to a nil or an empty string raise an exception! 
    raise NameError.new("#{self} cannot be converted to a valid method name!") if x.nil? || x == ''
    
    # get rid of the big stuff in the front/back
    x.strip!
    
    # if we get down to a nil or an empty string raise an exception! 
    raise NameError.new("#{self} cannot be converted to a valid method name!") if x.nil? || x == ''
    
    x = x.underscore
    
    # get rid of spaces and make the _
    x.gsub!(' ', '_')
    # get rid of everything that isn't 'safe' a-z, 0-9, ?, !, =, _
    x.gsub!(/([^ a-zA-Z0-9\_\?\!\=]+)/n, '_')
    
    # if we get down to a nil or an empty string raise an exception! 
    raise NameError.new("#{self} cannot be converted to a valid method name!") if x.nil? || x == ''
    
    # condense multiple 'safe' non a-z chars to just one.
    # ie. ___ becomes _ !!!! becomes ! etc...
    [' ', '_', '?', '!', "="].each do |c|
      x.squeeze!(c)
    end
    
    # if we get down to a nil or an empty string raise an exception! 
    raise NameError.new("#{self} cannot be converted to a valid method name!") if x.nil? || x == ''
    
    #down case the whole thing
    x.downcase!
    
    # get rid of any characters at the beginning that aren't a-z
    while !x.match(/^[a-z]/)
      x.slice!(0)
      
      # if we get down to a nil or an empty string raise an exception! 
      raise NameError.new("#{self} cannot be converted to a valid method name!") if x.nil? || x == ''
    end
    
    # let's trim this bad boy down a bit now that we've cleaned it up, somewhat.
    # we should do this before cleaning up the end character, because it's possible to end up with a 
    # bad char at the end if you trim too late.
    x = x[0..100] if x.length > 100
    
    # get rid of any characters at the end that aren't safe
    while !x.match(/[a-z0-9\?\!\=]$/)
      x.slice!(x.length - 1)
      # if we get down to a nil or an empty string raise an exception! 
      raise NameError.new("#{self} cannot be converted to a valid method name!") if x.nil? || x == ''
    end
    
    # if we get down to a nil or an empty string raise an exception! 
    raise NameError.new("#{self} cannot be converted to a valid method name!") if x.nil? || x == ''
    
    # let's get rid of characters that don't belong in the 'middle' of the method.
    orig_middle = x[1..(x.length - 2)]
    n_middle = orig_middle.dup
    
    ['?', '!', "="].each do |c|
      n_middle.gsub!(c, "_")
    end
    
    # the previous gsub can leave us with multiple underscores that need cleaning up.
    n_middle.squeeze!("_")
    
    x.gsub!(orig_middle, n_middle)
    x.gsub!("_=", "=")
    x
  end
  
  # Capitalizes the first word and turns underscores into spaces and strips _id.
  # Like titleize, this is meant for creating pretty output.
  #
  # Examples
  #   "employee_salary" #=> "Employee salary"
  #   "author_id" #=> "Author"
  def humanize
    self.gsub(/_id$/, "").gsub(/_/, " ").capitalize
  end
  
  # Returns a constant of the string.
  # 
  # Examples:
  #   "User".constantize # => User
  #   "HomeController".constantize # => HomeController
  #   "Mack::Configuration" # => Mack::Configuration
  def constantize
    Module.instance_eval("::#{self}")
  end
  
  def hexdigest
    Digest::SHA1.hexdigest(self)
  end                                    
  
  def hexdigest!
    self.replace(self.hexdigest)
  end
  
  def self.randomize(length = 10)
    chars = ("A".."H").to_a + ("J".."N").to_a + ("P".."T").to_a + ("W".."Z").to_a + ("3".."9").to_a
    newpass = ""
    1.upto(length) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass.upcase
  end
  
  # Performs URI escaping so that you can construct proper
  # query strings faster.  Use this rather than the cgi.rb
  # version since it's faster.  (Stolen from Camping).
  def uri_escape
    self.gsub(/([^ a-zA-Z0-9_.-]+)/n) {
      '%'+$1.unpack('H2'*$1.size).join('%').upcase
    }.tr(' ', '+')
  end

  # Unescapes a URI escaped string. (Stolen from Camping).
  def uri_unescape
    self.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n){
      [$1.delete('%')].pack('H*')
    }
  end
  
  def truncate(length = 30, truncate_string = "...")
    if self.nil? then return end
    l = length - truncate_string.length
    if $KCODE == "NONE"
      self.length > length ? self[0...l] + truncate_string : self
    else
      chars = self.split(//)
      chars.length > length ? chars[0...l].join + truncate_string : self
    end
  end
  
  def truncate!(length = 30, truncate_string = "...")
    self.replace(self.truncate(length, truncate_string))
  end
  
end