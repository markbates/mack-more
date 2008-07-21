module Mack
  module Javascript
    class ScriptGenerator    
      def initialize
        @lines = ''
      end

      def method_missing(sym, *args)
        self << self.class.framework.send(sym, *args)
      end

      def <<(s)
        @lines << s + ";"
      end

      def to_s
        @lines
      end

      def alert(message)
        self << "alert('#{message}')"
      end

      def call(*args, &block)
        s = args.shift + '('
        a = []
        args.each {|arg| a << arg.to_json}
        self << s + a.join(',') + ')'
      end

      def assign(variable, value)
        self << "#{variable} = #{value.to_json}"
      end

      def delay(seconds = 1, &block)
        self << "setTimeout(function() {\n\n" + yield(Mack::Javascript::ScriptGenerator.new) + "}, #{(seconds * 1000).to_i})"
      end

      class << self
        
        def framework
          "Mack::Javascript::Framework::#{framework_name}".constantize
        end

        def framework=(args)
          @@framework_name = args.camelcase
        end
        
        private
        def framework_name
          @@framework_name ||= app_config.mack.js_framework
        end
      end

    end
  end
end
