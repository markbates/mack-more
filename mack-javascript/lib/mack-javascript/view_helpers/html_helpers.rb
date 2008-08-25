module Mack
  module ViewHelpers # :nodoc:
    module HtmlHelpers
      # Renders javascript in an html file
      #
      # Example:
      #     <%= update_page do |page|
      #           page.alert('this gets translated to js!')
      #           page.show('my_hidden_div')
      #         end
      #     %>
      #This returns (assuming Prototype is your Js Framework):
      #     <script type='text/javascript'>
      #         alert('this gets translated to js!');
      #         $('my_hidden_div').show();
      #     </script>
      def update_page(&block)
        sg = Mack::JavaScript::ScriptGenerator.new
        yield(sg)
        "<script type='#{Mack::Utils::MimeTypes[:js]}'>\n" + sg.to_s.gsub(';', ";\n") + "</script>"
      end
      
      def link_to_remote(link_text, ajax_options, options = {})
        link_to_function(link_text, remote_function(ajax_options), options)
      end
      
      def link_to_function(link_text, *args, &block)
        function = args[0] || ''
        options = args[1] || {}
        function = yield(Mack::JavaScript::ScriptGenerator.new).chop if block_given?
        options[:onclick] = (options[:onclick] ? "#{options[:onclick]}; " : "") + "#{function}; return false;" 
        link_to(link_text, '#', options)
      end
      
      # Returns javascript that does an Ajax call
      def remote_function(options)
        Mack::JavaScript::ScriptGenerator.framework.remote_function(options)
      end
      
    end
  end
end
