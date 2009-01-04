require File.join_from_here('script_generator')

module Mack
  module JavaScript
    module Framework
      class PrototypeAjax
        @@callbacks = [:uninitialized, :loading, :loaded, :interactive, :complete, :failure, :success ] + 
        [100,101] + (200..206).to_a + (300..307).to_a + (400..417).to_a + (500..505).to_a
        class << self


          def remote_function(options)
            javascript_options = options_for_ajax(options)
            update = ''
            if options[:update] && options[:update].is_a?(Hash)
              update  = []
              update << "success:'#{options[:update][:success]}'" if options[:update][:success]
              update << "failure:'#{options[:update][:failure]}'" if options[:update][:failure]
              update  = '{' + update.join(',') + '}'
            elsif options[:update]
              update << "'#{options[:update]}'"
            end

            function = update.empty? ? 
            "new Ajax.Request(" :
            "new Ajax.Updater(#{update}, "

            url_options = options[:url]
            url_options = url_options.merge(:escape => false) if url_options.is_a?(Hash)
            function << "'#{url_options}'"
            function << ", #{javascript_options})"

            function = "#{options[:before]}; #{function}" if options[:before]
            function = "#{function}; #{options[:after]}"  if options[:after]
            function = "if (#{options[:condition]}) { #{function}; }" if options[:condition]
            function = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{function}; }" if options[:confirm]

            return function
          end

          protected
          def options_for_ajax(options)
            js_options = build_callbacks(options)
            js_options['asynchronous'] = options[:type] != :synchronous
            js_options['method']       = "'#{options[:method]}'" if options[:method]
            js_options['insertion']    = "Insertion.#{options[:position].to_s.camelize}" if options[:position]
            js_options['evalScripts']  = options[:script].nil? || options[:script]

            if options[:form]
              js_options['parameters'] = 'Form.serialize(this)'
            elsif options[:with]
              js_options['parameters'] = options[:with]
            end
            
            if options[:method].nil? || options[:method].to_sym != :get
              js_options['method'] = "'post'"
            else
              js_options['method'] = "'get'"
            end
            
            if options[:method] && options[:method].to_sym == :put || options[:method] == :delete
              js_options['parameters'] = append_ajax_data(js_options['parameters'], "_method=#{options[:method]}")
    				end
            
            if js_options['method'] == "'post'" && options[:authenticity_token]
              js_options['parameters'] = append_ajax_data(js_options['parameters'], "__authenticity_token=#{options.delete(:authenticity_token)}")
            end
            
            
            options_for_javascript(js_options.reject {|key, value| value.nil?})
          end
          
          def append_ajax_data(data, new_data)
            if data
							data << " + '&"
						else
							data = "'"
						end
						data << "#{new_data}'"
          end

          def options_for_javascript(options)
            '{' + options.map {|k, v| "#{k}:#{v}"}.sort.join(', ') + '}'
          end

          def build_callbacks(options)
            callbacks = {}
            options.each do |callback, code|
              if @@callbacks.include?(callback)
                name = 'on' + callback.to_s.capitalize
                callbacks[name] = "function(request){#{code}}"
              end
            end
            callbacks
          end

        end
      end
      
      class PrototypeSelector < Mack::JavaScript::Selector 

        def select
          "$$(#{@selector})"
        end

        def invoke(arr, options = {})
          arr.collect! do |arg| 
            if !arg.is_a?(String) || arg =~ /^function/ || arg =~ /^null$/ || arg =~ /^\{.*\}$/ 
              arg
            else
              "'#{arg}'"
            end
          end
          function = "invoke(#{arr.compact.join(',')})"
          function << '.flatten().uniq()' if options.delete(:flatten_uniq)
          add function, options
        end

        def each(func, options = {})
          add "each(function(elem){#{func}})",  options
        end


        #--- Tree Walking ---#
        
        # Will give you the immediate children underneath the selected elements
        #
        #
        # Example: 
        # say you have the following html:
        #
        # <div class='rakim'>
        #   <ul>
        #     ...
        #   </ul>
        # </div>
        #
        # <div class='rakim'>
        #   <p>Eric B</p>
        #   <div id='technique'>
        #     ...
        #   </div>
        # </div>
        #
        # page.select('.rakim').children would give you a collection consisting of
        # the ul element, the p element, and the div with id 'technique'
        def children
      	  invoke ["childElements"], :flatten_uniq => true
        end
        
        # returns a collection of the immediate parent of each selected element
      	def parent
      	  invoke ["up"], :flatten_uniq => true
        end
        
        # returns a collection of every parent up the chain to the root of the document
        # for each selected element.
      	def ancestors
      	  invoke ["ancestors"], :flatten_uniq => true
        end
        
        # gets all siblings for each element selected
      	def siblings(selector = nil)
      	  invoke ["siblings", selector], :flatten_uniq => true
        end
        
        # gets the next immediate sibling for each element selected
        # Takes an optional selector as an argument
        def next(selector = nil)
          invoke ["next", selector], :flatten_uniq => true
        end
        
        # gets the previous immediate sibling for each element selected
        # Takes an optional selector as an argument
        def previous(selector = nil)
          invoke ["prev", selector], :flatten_uniq => true
        end
        
        # gets every next sibling for each element selected
        def all_next
          invoke ["nextSiblings"], :flatten_uniq => true
        end
        
        # gets every previous sibling for each element selected
        def all_previous
          invoke ["previousSiblings"], :flatten_uniq => true
        end


        #-- Attributes --#

        def add_class(klass)
          invoke ["addClassName", klass]
        end

        def remove_class(klass = '')
          invoke ["removeClassName", klass]
        end

        def set_attribute(name, value)
          value = "null" if value.nil?
          invoke ["writeAttribute", name, value]
        end

        def remove_attribute(name)
          set_attribute(name, nil)
        end



      	#-- DOM Manipulation --#
        
        # inserts html into the selected place for the specfied elemets
        #
      	# +position+ may be one of:
        # 
        # <tt>:top</tt>::    HTML is inserted inside the element, before the 
        #                    element's existing content.
        # <tt>:bottom</tt>:: HTML is inserted inside the element, after the
        #                    element's existing content.
        # <tt>:before</tt>:: HTML is inserted immediately preceding the element.
        # <tt>:after</tt>::  HTML is inserted immediately following the element.
        #
        #
        # Example
        #
        # <div class='rakim'>
        #   <ul>
        #     ...
        #   </ul>
        # </div>
        #
        # <div class='rakim'>
        #   <p>Eric B</p>
        #   <div id='technique'>
        #     ...
        #   </div>
        # </div>
        #
        # page.select('.rakim').insert(:before, "<h1> The R </h1>") would result in:
        #
        # <h1> The R </h2>
        # <div class='rakim'>
        #   <ul>
        #     ...
        #   </ul>
        # </div>
        #
        # <h1> The R </h2>
        # <div class='rakim'>
        #   <p>Eric B</p>
        #   <div id='technique'>
        #     ...
        #   </div>
        # </div>
        #
        #
        # Tip: use this with a partial containing your html:
        # page.select('.rakim').insert(:before, render(:partial, 'the_r', :format => :html))
      	def insert(position, html)
          invoke ["insert", "{#{position.to_s}: '#{escape_javascript(html)}'}"]
        end


        # replaces the selected html.
        #
        # +repace+ may be:
        # 
        # <tt>:inner</tt>::  The inner html of the selected elements
        #                    are replaced
        # <tt>:outer</tt>::  the selected elements themselves are replaced
        #
        # Example
        #
        # <div class='rakim'>
        #   <p>Dont Sweat the Techinique</p>
        # </div>
        # <div class='rakim'>
        #   <p>Follow the Leader</p>
        # </div>
        #
        # page.select('.rakim').replace(:inner, "<p>Paid in Full</p>") would result in 
        #
        # <div class='rakim'>
        #   <p>Paid in Full</p>
        # </div>
        # <div class='rakim'>
        #   <p>Paid in Full</p>
        # </div>
        #
        # if we then did:
        # page.select('.rakim').replace(:outer, "<div class='schoolyD'><p>SaturdayNight</p></div>")
        # the result would be
        #
        # <div class='schoolyD'>
        #   <p>SaturdayNight</p>
        # </div>
        # <div class='schoolyD'>
        #   <p>SaturdayNight</p>
        # </div>
        def replace(replace, html)
          function =  {:inner =>"update",:outer => 'replace'}[replace.to_sym]
          invoke [function, escape_javascript(html)]
        end
        
        #removes the selected elements from the DOM
        def remove
          invoke ['remove']
        end


      	#-- Effects --#
        # 
        # The methods morph and effect take the same options hash. This can consist of:
        # 
        # <tt>:duration</tt>::  The duration of the effect in ms.
        # <tt>:easing</tt>::    see below
        # <tt>:fps</tt>::       Specifies the frames-per-second value. The default is 25. 
        # <tt>:sync</tt>::      Synchronizes effects when applied in parallel. 
        # <tt>:queue</tt>::     Sets the queuing position for effect queues.
        #
        #
        #  --Easing--
        # This determines the mathematical function your effect will use while transitioning. 
        # For instance, if you do page.select(.rakim).effect(:slideUp, :easing => 'spring'),
        # every element with class 'rakim' will slide up and when it reaches the top, they will 
        # bounce back down a little then go back up.
        #
        # The full list of prototype easing options:
      	# linear, sinoidal, reverse, flicker, wobble, pulse, spring, none, full

      	def morph(hsh, options = nil)
      	  #hsh is an object of style values
      	  invoke ['morph', options_for_javascript(hsh), options_for_effects(options)]
        end
        
        # Custom visual effects. Supports the following effect names:
        # highlight, scale, opacity, move, fade, appear, blindUp, blindDown, slideUp, slideDown, 
        # dropOut, grow, shrink, puff, switchOff, squish, fold, pulsate, shake, scrollTo
        def effect(name, options = nil)
          invoke ['visualEffect', name.to_s, options_for_effects(options)]
        end

        # show() shows an element, hide() hides it, and toggle() shows a hidden and hides a shown.
        def show()
          invoke ['show']
        end

        def hide()
          invoke ['hide']
        end

        def toggle()
          invoke ['toggle']
        end



        #-- Events --#

        # adds an event listener to the selected elements. If options[:prevent_default] == true
        # the default behavior of the event isn't taken
        #
        # Example
        #
        # page.select('.rakim a').peep 'click', :prevent_default => true do |p|
        #   p.select('#sucka_mcs').effect(:fade)
        # end
        #
        # After running this code, if you click any a tag under any element with the
        # class 'rakim', the element with id "sucka_mcs" will fade. Because of the option
        # :prevent_default => true, the default action when clicking the a tag (the browser
        # goes to its href url) isn't done.
        # This can also be used in conjunction with trigger to make and call custom events.
        def peep(event_name, options = {}, &block)
          invoke ["observe", event_name, event_function(options[:prevent_default], &block)]
        end
        
        #takes away any event listeners on the 'event_name' event fot the selected elements
        def stop_peeping(event_name)
          invoke ["stopObserving", event_name]
        end
        
        # triggers the 'event_name' event on the selected elements.
        def trigger(event_name)
          invoke ["fire", event_name]
        end
        
        
        
        
        #-- Drag and Drop--#

        # Makes the selected elements draggable. 
        #
        # options
      	# http://github.com/madrobby/scriptaculous/wikis/draggable
      	# <tt>:revert</tt>::     	if true, will revert after being dropped. ‘failure’
      	#                         will instruct the draggable not to revert if 
      	#                         successfully dropped in a droppable. 
      	# <tt>:ghosting</tt>::    if true, will clone the element and drag the clone
      	# <tt>:zindex</tt>::      The css z-index of the draggable item. 
        def draggable(options = nil)
          each "new Draggable(elem, #{options_for_effects(options)})"
        end
        
        # Makes the selected elements droppable. 
        #
        # options are 
        # http://github.com/madrobby/scriptaculous/wikis/droppables
        
        # <tt>:accept</tt>::        if set to a css class, the selected elements will only
        #                           accept elements dragged to it with that class.
        # <tt>:hoverclass</tt>::    a droppable element will have this class added to it
        #                           when an element is dragged over it.
        # <tt>:remote</tt>::        takes a hash of ajax options, the same as given to page.ajax
        #                           if this options is, an ajax call is made using the specified
        #                           options along. Added to the url is an id parameter which
        #                           has the id of the element that was dropped
        # 
        # if a block is given, the blocks code will be executed when a succesful drop is done.
        #
        # Example
        #
        # options = {:remote => {:url => '/stuff'}}
        # page.select('#bucket').droppable options do |p|
        #   p.alert('you dropped it!')
        # end
        #
        # This code will make the element with id 'bucket' droppable. If an element is 
        # dropped onto it, an ajax call to the url '/stuff' will be sent with an id
        # parameter of the id of the dropped element. Then an js alert
        # box with the message 'you dropped it' will appear.
        def droppable(options = nil, &block)
          remote_options = options.delete(:remote)
          if remote_options || block_given?
            func =  Mack::JavaScript::Function.new(session_id, 'elem')
            if remote_options
    					remote_options[:with] ||= "'id=' + elem.id"
    					func << Mack::JavaScript::ScriptGenerator.new(session_id).ajax(remote_options)
    				end
    				func.body(&block) if block_given?
    				options.merge!(:onDrop => func)
  				end
          each "Droppables.add(elem, #{options_for_effects(options)})"
        end


        private
        
        def build_multiple_selector_string(selector)
          selector.collect{|s| "'#{s}'"}.join(',')
        end

        def options_for_effects(options)
          return nil unless options
          options[:duration] = (options[:duration]/1000.0) if options[:duration]
          easing = options.delete(:easing)
          options[:transition] = "function(){return Effect.Transitions.#{easing}}()" if easing
          options_for_javascript(options)
        end
        
        def options_for_javascript(options)
          options = options.collect do |key, value|
            value = "'#{value}'" unless !value.is_a?(String) || value =~ /^function/
            "#{key}: #{value}"
          end
          "{#{options.join(',')}}"
        end
        
        def event_function(prevent_default = false, &block)
          func =  Mack::JavaScript::Function.new(session_id, 'event')
          func << "event.stop()" if prevent_default
          func.body(&block)
        end

      end
    end
  end
end