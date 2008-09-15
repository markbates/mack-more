module Mack
  module Utils # :nodoc:
    module Crypt # :nodoc:
      # The default worker is one that is used when no other worker is specified or the 
      # specified worker does not exist. It uses the EzCrypto library and get's 
      # it's secret key from configatron.default_secret_key
      class DefaultWorker
        
        def initialize
          @aes_key = EzCrypto::Key.with_password((configatron.default_secret_key || (String.randomize(40))), Mack::VERSION)
        end
        
        # Encrypts a string using the EzCrypto library and the secret key found in
        # configatron.default_secret_key
        def encrypt(x)
          @aes_key.encrypt(x)
        end
        
        # Decrypts a string using the EzCrypto library and the secret key found in
        # configatron.default_secret_key
        def decrypt(x)
          @aes_key.decrypt(x)
        end
        
      end # DefaultWorker
    end # Crypt
  end # Utils
end # Mack