module Mack
  module Distributed
    
    def self.const_missing(const)
      Mack::Distributed::Utils::Rinda.read(:klass_def => "#{const}".to_sym)
    end
    
  end # Distributed
end # Mack