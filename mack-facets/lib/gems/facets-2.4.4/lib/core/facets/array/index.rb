class Array

  if RUBY_VERSION < '1.9'

    alias_method :facets_override_of_index, :index

    #private :facets_override_of_index

    # Allows #index to accept a block.
    #
    # OVERRIDE! This is one of the bery few core
    # overrides in Facets.
    #
    def index(obj=nil, &block)
      return facets_override_of_index(obj) unless block_given?
      i=0; i+=1 until yield(self[i])
      return i
    end

  end

end

