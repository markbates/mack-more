module Mack
  module Errors # :nodoc:
    
    class UnconvertedNotifier < StandardError
      def initialize # :nodoc:
        super("You must convert the Mack::Notifier object first!")
      end
    end # UnconvertedNotifier
    
    class XmppError < StandardError
      def initialize(msg)
        super(msg)
        self.error_hash = {}
      end
      
      def add_error(type, msg)
        self.error_hash[type] ||= []
        self.error_hash[type] << msg
      end
      
      def get_error(type)
        self.error_hash[type]
      end
      
      def empty?
        self.error_hash.empty?
      end
      
      attr_accessor :error_hash
    end
    
    class XmppAuthenticationError < StandardError
      def initialize(user)
        super("Cannot authenticate: #{user} to xmpp server")
      end
    end
    
    class XmppUserNotOnline < StandardError
      def initialize(user)
        super("user #{user} is not online")
      end
    end
    
    class XmppSendError < StandardError
      attr_reader :code
      attr_reader :msg
      
      def initialize(code, msg)
        super("Cannot send message. Code=#{code}, Msg=#{msg}")
        @code = code
        @msg = msg
      end
    end
  end # Errors
end # Mack