require 'uri'
class Hash
  
  def join(pair_string, join_string)
    output = []
    sorted = self.sort {|a,b| a[0].to_s <=> b[0].to_s}
    sorted.each do |ar|
      output << sprintf(pair_string, ar[0], ar[1])
    end
    output.join(join_string)
  end
  
  # Deletes the key(s) passed in from the hash.
  def -(ars)
    [ars].flatten.each {|a| self.delete(a)}
    self
  end
  
  # Converts a hash to query string parameters. 
  # An optional boolean escapes the values if true, which is the default.
  def to_params(escape = true)
    params = ''
    stack = []
    
    each do |k, v|
      if v.is_a?(Hash)
        stack << [k,v]
      else
        v = v.to_s.uri_escape if escape
        params << "#{k}=#{v}&"
      end
    end
    
    stack.each do |parent, hash|
      hash.each do |k, v|
        if v.is_a?(Hash)
          stack << ["#{parent}[#{k}]", v]
        else
          v = v.to_s.uri_escape if escape
          params << "#{parent}[#{k}]=#{v}&"
        end
      end
    end
    
    params.chop! # trailing &
    params.split("&").sort.join("&")
  end
  
end