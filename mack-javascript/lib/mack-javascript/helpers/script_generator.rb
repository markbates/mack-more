require File.join_from_here('..', 'view_helpers', 'string_helpers')

module Mack
  module JavaScript
    class ScriptGenerator
       
      attr_reader :session_id
      
      def initialize(session_id = nil)
        @lines = []
        @session_id = session_id
      end
      
      # selects elements on the page using css3 selectors
      # For more info: http://www.w3.org/TR/css3-selectors/
      # A few useful examples: 'div' would select all divs. '.full' would
      # select all elements with class 'full'. 'div.blah' would select
      # all divs with class 'blah'. '#foo' would select the element
      # with id 'foo'
      #
      # select can take multiple selector strings. For instance
      # page.select('ul.blah', '#foo', '.full') would give you access to 
      # a collection of elements containing all uls with class 'blah', the
      # element with id 'foo' and every element with class 'full'. See
      # JquerySelector or PrototypeSelector for available methods on
      # the returned collection.
      def select(*selector)
        self.class.selector_framework.new(self, *selector)
      end

      def ajax(options)
        unless configatron.mack.disable_forgery_detector || !session_id
          options.merge!(:authenticity_token => Mack::Utils::AuthenticityTokenDispenser.instance.dispense_token(session_id))
        end
        self << self.class.ajax_framework.remote_function(options)
      end

      def <<(s, options = {})
        if options[:add_to_last]
          @lines.last << s
        else
          @lines << s
        end
      end

      def to_s
        string = @lines.join(';')
        string << ';' unless string =~ /;$/
        string
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
      
      def function(*args)
        Mack::JavaScript::Function.new(session_id, *args)
      end

      def assign(variable, value)
        self << "#{variable} = #{value.to_json}"
      end

      def delay(seconds = 1, &block)
        self << "setTimeout(#{function.body(&block)}, #{(seconds * 1000).to_i})"
      end
      
      
      #-- Deprecated Methods --# 
      
      def insert_html(position, id, html)
        deprecate_method(:insert_html, 'page.select("#id").insert(position, html)', '0.8.3')
        self.select("##{id}").insert(position, html)
      end

      def replace_html(id, html)
        deprecate_method(:replace_html, 'page.select("#id").replace(:inner, html)', '0.8.3')
        self.select("##{id}").replace(:inner, html).to_s
      end

      def replace(id, html)
        deprecate_method(:replace, 'page.select("#id").replace(:outer, html)', '0.8.3')
        self.select("##{id}").replace(:outer, html).to_s
      end
      
      def remove(*ids)
        deprecate_method(:remove, 'page.select("#id1", "#id2").remove', '0.8.3')
        ids = [ids] if ids.is_a? String
        ids.collect! {|id| "##{id}"}
        self.select(*ids).remove
      end

      def show(*ids)
        deprecate_method(:show, 'page.select("#id1", "#id2").show', '0.8.3')
        ids = [ids] if ids.is_a? String
        ids.collect! {|id| "##{id}"}
        self.select(*ids).show
      end
      
      def hide(*ids)
        deprecate_method(:hide, 'page.select("#id1", "#id2").hide', '0.8.3')
        ids = [ids] if ids.is_a? String
        ids.collect! {|id| "##{id}"}
        self.select(*ids).hide
      end

      def toggle(*ids)
        deprecate_method(:toggle, 'page.select("#id1", "#id2").toggle', '0.8.3')
        ids = [ids] if ids.is_a? String
        ids.collect! {|id| "##{id}"}
        self.select(*ids).toggle
      end

      class << self
        
        def ajax_framework
          ivar_cache('ajax_framework') do
            "Mack::JavaScript::Framework::#{framework_name}Ajax".constantize
          end
        end
        
        def selector_framework
          ivar_cache('selector_framework') do
            "Mack::JavaScript::Framework::#{framework_name}Selector".constantize
          end
        end

        def framework=(args)
          @ajax_framework = nil
          @selector_framework = nil
          @@framework_name = args.camelcase
        end
        
        private
        def framework_name
          @@framework_name ||= configatron.mack.js_framework.camelcase
        end
      end
    end      
      
    class Selector
      include Mack::ViewHelpers::StringHelpers
      
      attr_reader :session_id
      
      def initialize(generator, *sel)
        @generator = generator
        @session_id = generator.session_id
        @selector = sel.first == 'this' ? 'this' : build_multiple_selector_string(sel)
        @generator << select
      end

      def add(statement, options = {})
        @generator.<<(".#{statement}", :add_to_last => true)
        self
      end

    end
    
    
    class Function
      
      def initialize(session_id = nil, *args)
        if args.first.is_a? Fixnum
          args = Array.new(args.first){|i| i + 1}.collect{|x| "obj#{x}"}
        end
        @session_id = session_id
        @arguments = args
        @generator = Mack::JavaScript::ScriptGenerator.new(session_id)
      end
      
      def <<(*args)
        @generator << args
        to_s
      end
      
      def body(&block)
        yield @generator
        to_s
      end
      
      
      def to_s
        "function(#{@arguments.join(', ')}){#{@generator.to_s}}"
      end
      
      
    end
  end
end