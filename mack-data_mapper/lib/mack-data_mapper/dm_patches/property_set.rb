module DataMapper # :nodoc:
  class PropertySet # :nodoc:
    
    def []=(name, property)
      if existing_property = detect { |p| p.name == name }
        property.hash
        @entries[@entries.index(existing_property)] = property
      else
        add(property)
      end
      property
    end
    
  end # class PropertySet
end # module DataMapper
