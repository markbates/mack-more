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
        gs = js
        yield(gs)
        "<script type='#{Mack::Utils::MimeTypes[:js]}'>\n" + gs.to_s.gsub(';', ";\n") + "</script>"
      end
      
      def link_to_remote(link_text, ajax_options, options = {})
        link_to_function(link_text, remote_function(ajax_options), options)
      end
      
      def link_to_function(link_text, *args, &block)
        function = args[0] || ''
        options = args[1] || {}
        function = yield(js).chop if block_given?
        options[:onclick] = (options[:onclick] ? "#{options[:onclick]}; " : "") + "#{function}; return false;" 
        link_to(link_text, '#', options)
      end
      
      # Returns javascript that does an Ajax call
      def remote_function(options)
        Mack::JavaScript::ScriptGenerator.framework.remote_function(options)
      end
      
      def js
        Mack::JavaScript::ScriptGenerator.new
      end
      
      # Returns a button that links to a remote function. 
      # 
      # Example:
      #   button_to_remote('Create', :url => '/foo') # => <button onclick="new Ajax.Request('/foo', {asynchronous:true, evalScripts:true, parameters:Form.serialize(this.form)}); return false" type="submit">Create</button>
      def button_to_remote(value = "Submit", options = {}, *original_args)
        with = options.delete(:with) || 'Form.serialize(this.form)'
        url = options.delete(:url) || '#'
        options[:onclick] = remote_function(:with => with, :url => url) + '; return false'
        submit_button(value, options, *original_args)
      end
      
    end
  end
end
