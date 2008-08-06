module Mack # :nodoc:
  module Distributed # :nodoc:
    
    # Looks up and tries to find the missing constant using the ring server.
    def self.const_missing(const)
      Mack::Distributed::Utils::Rinda.read(:klass_def => "#{const}".to_sym)
    end
    
  end # Distributed
end # Mack