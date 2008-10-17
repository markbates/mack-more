module Mack
  module Distributed
    class ViewCache < Cachetastic::Caches::Base
      
      class << self
        include Mack::ViewHelpers
      
        def get(path)
          raw = super(path) do
            raw = ""
            if File.exists?(path)
              raw = File.read(path)

              # preprocess the raw content so we can resolve css/javascript/image path
              arr = raw.scan(/<%=.*?%>/)
              arr.each do |scriptlet|
                if scriptlet.match(/stylesheet/) or scriptlet.match(/javascript/) or scriptlet.match(/image/)
                  res = ERB.new(scriptlet).result(binding)
                  raw.gsub!(scriptlet, res)
                end 
              end # if arr.each
            end # if File.exists?
            
            set(path, raw)
          end # super(key)
          return raw
        end # def get
      end # class << self
      
    end # ViewCache
  end # Distributed
end # Mack