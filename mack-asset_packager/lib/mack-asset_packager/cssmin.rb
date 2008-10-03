class CSSMin
  
  attr_accessor :data
  def initialize(content)
    self.data = content
  end
  
  def minimize
    # find all elements in between { and }, and remove \n and \t
    # self.data.scan(/\{([.|\s\S]*?)\}/).flatten.each do |elt|
    #   str = elt.gsub("\n", "")
    #   str = str.gsub("\t", "")
    #   self.data.gsub!(elt, str)
    # end
    
    self.data = self.data.squeeze(" ").squeeze("\t").squeeze("\n")
    self.data.gsub!("\t", "")
    
    # remove comments in the form of /* ... */ 
    self.data.gsub!(/\/\*[.|\s|\S]*?\*\//, "")
    
    # remove newline before and after {
    self.data.gsub!("\n\{", " \{")
    self.data.gsub!("\{\n", " \{")
    
    # remove newline after ,
    self.data.gsub!(",\n", ", ")
    
    # remove spaces after/before ...
    self.data.gsub!(": ", ":")
    self.data.gsub!(" :", ":")
    self.data.gsub!(", ", ",")
    self.data.gsub!(" ,", ",")
    self.data.gsub!("; ", ";")
    self.data.gsub!(" ;", ";")
    self.data.gsub!(";\}", "\}")
    self.data.gsub!(" \}", "\}")
    self.data.gsub!("\{ ", "\{")
    self.data.gsub!(" \{", "\{")
        
    # remove all new line, but add one after }
    self.data.gsub!("\n", "")
    self.data.gsub!("\}", "\}\n")
    
    self.data = self.data.squeeze(" ").squeeze("\t").squeeze("\n").strip
    
    return self.data
  end
end