require File.join_from_here('script_generator')

module Mack
  module JavaScript # :nodoc:
    module Framework # :nodoc:
      class JqueryAjax
        class << self
          
          def remote_function(options)
            javascript_options = options_for_ajax(options)
            function = "$.ajax(#{javascript_options})"

            function = "#{options[:before]}; #{function}" if options[:before]
            function = "#{function}; #{options[:after]}"  if options[:after]
            function = "if (#{options[:condition]}) { #{function}; }" if options[:condition]
            function = "if (confirm('#{escape_javascript(options[:confirm])}')) { #{function}; }" if options[:confirm]
            return function
          end

          protected
          def options_for_ajax(options)
            js_options = build_callbacks(options)
            js_options['url'] = "'#{options[:url]}'"
            js_options['async'] = options[:type] != :synchronous
            
            
            js_options['dataType'] = options[:datatype] ? "'#{options[:datatype]}'" : (options[:update] ? nil : "'script'")
            
            
            if options[:form]
              js_options['data'] = "$.param($(this).serializeArray())"
            elsif options[:with]
              js_options['data'] = options[:with].gsub('Form.serialize(this.form)','$.param($(this.form).serializeArray())')
            end
            
            if options[:method].nil? || options[:method].to_sym != :get
              js_options['type'] = "'post'"
            else
              js_options['type'] = "'get'"
            end
            
            if options[:method] && options[:method].to_sym == :put || options[:method] == :delete
              js_options['data'] = append_ajax_data(js_options['data'], "_method=#{options[:method]}")
            end
            
            if js_options['type'] == "'post'" && options[:authenticity_token]
              js_options['data'] = append_ajax_data(js_options['data'], "__authenticity_token=#{options.delete(:authenticity_token)}")
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
            options[:beforeSend] = '';
            [:uninitialized,:loading,:loaded].each do |key|
              options[:beforeSend] << (options[key].last == ';' ? options.delete(key) : options.delete(key) << ';') if options[key]
            end
            options.delete(:beforeSend) if options[:beforeSend].blank?
            options[:error] = options.delete(:failure) if options[:failure]
            if options[:update]
              options[:success] = build_update(options) << (options[:success] ? options[:success] : '')
            end
            options.each do |callback, code|
              if [:beforeSend, :complete, :error, :success ].include?(callback)
                callbacks[callback] = "function(request){#{code}}"
              end
            end
            callbacks
          end

          def build_update(options)
            insertion = 'html'
            insertion = options[:position].to_s.downcase if options[:position]
            insertion = 'append' if insertion == 'bottom'
            insertion = 'prepend' if insertion == 'top'
            "$('##{options[:update]}').#{insertion}(request);"
          end

        end

      end
      
      class JquerySelector < Mack::JavaScript::Selector     
        
        def select
          "$(#{@selector})"
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
          add "children()"
        end
        
        # returns a collection of the immediate parent of each selected element
        def parent
          add "parent()"
        end
        
        # returns a collection of every parent up the chain to the root of the document
        # for each selected element. This method also takes an optional selector as an argument.
        #
        # Example:
        #
        # for the html
        #
        # <div class='big_daddy_kane'>
        #   <div id='long_live'>
        #     <ul class='raw'>
        #       <li id='featuring'>with Kool G Rap</li>
        #     </ul>
        #   </div>
        # </div>
        #
        # page.select('#featuring').ancestors will give you a collection consisting
        # of both divs and the ul. 
        # page.select('#featuring').ancestors('#long_live') will give you the div with
        # id 'long_live'
        def ancestors(selector = nil)
          add "parents(#{optional_selector(selector)})"
        end
        
        # gets all siblings for each element selected
        # Takes an optional selector as an argument
        def siblings(selector = nil)
          add "siblings(#{optional_selector(selector)})"
        end
        
        # gets the next immediate sibling for each element selected
        # Takes an optional selector as an argument
        def next(selector = nil)
          add "next(#{optional_selector(selector)})"
        end
        
        # gets the previous immediate sibling for each element selected
        # Takes an optional selector as an argument
        def previous(selector = nil)
          add "prev(#{optional_selector(selector)})"
        end
        
        # gets every next sibling for each element selected
        # Takes an optional selector as an argument
        def all_next(selector = nil)
          add "nextAll(#{optional_selector(selector)})"
        end
        
        # gets every previous sibling for each element selected
        # Takes an optional selector as an argument
        def all_previous(selector = nil)
          add "prevAll(#{optional_selector(selector)})"
        end





        #-- Attributes --#

        def add_class(klass)
          add "addClass('#{klass}')"
        end
        
        
        def remove_class(klass = '')
          add "removeClass('#{klass}')"
        end

        def set_attribute(name, value)
          value = "'#{value}'" if value.is_a? String
          add "attr('#{name}', #{value})" 
        end

        def remove_attribute(name)
          add "removeAttr('#{name}')"
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
          position = {:bottom => 'append', :top => 'prepend'}[position.to_sym] || position.to_s
          add "#{position}('#{escape_javascript(html)}')"
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
          function =  {:inner =>"html",:outer => 'replaceWith'}[replace.to_sym]
          add "#{function}('#{escape_javascript(html)}')"
        end
        
        #removes the selected elements from the DOM
        def remove
          add "remove()"
        end



        #-- Effects --#
        # 
        # All five effects methods in JquerySelector (morph, effect, show, hide, toggle)
        # take the same options hash. This can consist of:
        # 
        # <tt>:duration</tt>::  The duration of the effect in ms.
        # <tt>:easing</tt>::    see below
        # <tt>:callback</tt>::  see below
        # <tt>:queue</tt>::     If false, the animation isn’t queued and begins running 
        #                       immediately.
        #
        #
        #  --Easing--
        # This determines the mathematical function your effect will use while transitioning. 
        # For instance, if you do page.select(.rakim).effect(:slideUp, :easing => 'easeOutBounce'),
        # every element with class 'rakim' will slide up and when it reaches the top, they will 
        # bounce back down a little then go back up. To visualize this better, see
        # http://www.robertpenner.com/easing/easing_demo.html
        #
        # The full list of jquery easing options:
        # linear, swing, easeInQuad, easeOutQuad, easeInOutQuad, easeInCubic, easeOutCubic, 
        # easeInOutCubic, easeInQuart, easeOutQuart, easeInOutQuart, easeInQuint, easeOutQuint,
        # easeInOutQuint, easeInSine, easeOutSine, easeInOutSine, easeInExpo, easeOutExpo, 
        # easeInOutExpo, easeInCirc, easeOutCirc, easeInOutCirc, easeInElastic, easeOutElastic,
        # easeInOutElastic, easeInBack, easeOutBack, easeInOutBack, easeInBounce, easeOutBounce,
        # easeInOutBounce:
        #
        # --Callback--
        #
        # this is a function that will get called when your effect is done. You can use 
        # page.function to build it. Note: This function gets called for each element selected.
        # For instance, in the following example, if there are 10 elements with the class 'rakim'
        # then the function will be called 10 times. If you want to target each of the 10 elements
        # in the callback function, use page.select('this')
        #
        # func = page.function.body do |p|
        #          p.select('this').insert(:top, '<h1>Cool Effects</h1>').effect(:highlight)
        #        end
        # page.select('.rakim').effect(:slide_down, :callback => func)
        #
        # The above code will make every element with class 'rakim' slide down. When they are done
        # sliding, the h1 tag will be inserted in the top of each element, and each element will 
        # be highlighted. Instead of this, you could do the following
        # page.select('.rakim').effect(:slide_down).insert(:top, '<h1>Cool Effects</h1>').effect(:highlight)
        # But this way, the insertion won't wait for the first animation to be done before occurring.
        
        
        
        # Takes a hash of css properties you want the selected elements to 'morph' into.
        # Say you want all elements with class rakim to transition to only having half
        # the opacity and having a red background, and you want the transition to last 4
        # seconds
        # page.select('.rakim').morph({:opacity => 0.5, :backgroundColor => '#f00'}, :duration => 4000)
        # You can see a list of css properties here http://www.w3schools.com/CSS/css_reference.asp
        # The properties in your hash should be camelcase: :backgroundColor instead of
        # background-color
        def morph(hsh, options = nil)
          options[:complete] = options.delete(:callback) if options && options[:callback]
          args = [options_for_javascript(hsh), options_for_effects(options)]
          add "animate(#{args.compact.join(',')})"
        end

        #This general mapping taken from the awesome JRails plugin
        @@effects = {
          :appear => {:function => 'fadeIn'},
          :blind_down => {:mode => 'blind', :function => 'show', :options => {:direction => 'vertical'}},
          :blind_up => {:mode => 'blind', :function => 'hide', :options => {:direction => 'vertical'}},
          :blind_right => {:mode => 'blind', :function => 'show', :options => {:direction => 'horizontal'}},
          :blind_left => {:mode => 'blind', :function => 'hide', :options => {:direction => 'horizontal'}},
          :bounce_in => {:mode => 'bounce', :function => 'show', :options => {:direction => 'up'}},
          :bounce_out => {:mode => 'bounce', :function => 'hide', :options => {:direction => 'up'}},
          :drop_in => {:mode => 'drop', :function => 'show', :options => {:direction => 'up'}},
          :drop_out => {:mode => 'drop', :function => 'hide', :options => {:direction => 'down'}},
          :fade => {:function => 'fadeOut'},
          :fold_in => {:mode => 'fold', :function => 'hide'},
          :fold_out => {:mode => 'fold', :function => 'show'},
          :grow => {:mode => 'scale', :function => 'show'},
          :highlight => {:mode => 'highlight', :function => 'show'},
          :puff => {:mode => 'puff', :function => 'hide'},
          :pulsate => {:mode => 'pulsate', :function => 'show'},
          :shake => {:mode => 'shake', :function => 'show'},
          :shrink => {:mode => 'scale', :function => 'hide'},
          :slide_down => {:mode => 'slide', :function => 'show', :options => {:direction => 'up'}},
          :slide_up => {:mode => 'slide', :function => 'hide', :options => {:direction => 'up'}},
          :slide_right => {:mode => 'slide', :function => 'show', :options => {:direction => 'left'}},
          :slide_left => {:mode => 'slide', :function => 'hide', :options => {:direction => 'left'}},
          :squish => {:mode => 'scale', :function => 'hide', :options => {:origin => "['top','left']"}},
          :switch_on => {:mode => 'clip', :function => 'show', :options => {:direction => 'vertical'}},
          :switch_off => {:mode => 'clip', :function => 'hide', :options => {:direction => 'vertical'}},
          :toggle_appear => {:function => 'fadeToggle'},
          :toggle_slide => {:mode => 'slide', :function => 'toggle', :options => {:direction => 'up'}},
          :toggle_blind => {:mode => 'blind', :function => 'toggle', :options => {:direction => 'vertical'}},
        }

        #custom effects. 'name' corresponds to the keys of the hash above
        def effect(name, options = nil)
          effect = @@effects[name]
          args = [effect[:mode] ? "'#{effect[:mode]}'" : nil,    
                  options_for_effects((effect[:options] || {}).merge(options || {}))]
          add "#{effect[:function]}(#{args.compact.join(',')})"
        end

        # show() shows an element, hide() hides it, and toggle() shows a hidden and hides a shown.
        #
        # The first parameter, fx, can be any one of the following: blind, bounce, clip, core, 
        # drop, explode, fold, highlight, pulsate, scale, shake, slide. 
        # You can see above that the majority of the custom effects are built using either 
        # show or hide paired with an fx
        # Note: the arguments for the following three methods are unique to jquery
        def show(fx = nil, options = nil)
          args = [fx ? "'#{fx}'" : nil, options_for_effects(options)]
          add "show(#{args.compact.join(',')})"
        end

        def hide(fx = nil, options = nil)
          args = [fx ? "'#{fx}'" : nil, options_for_effects(options)]
          add "hide(#{args.compact.join(',')})"
        end

        def toggle(fx = nil, options = nil)
          args = [fx ? "'#{fx}'" : nil, options_for_effects(options)]
          add "toggle(#{args.compact.join(',')})"
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
          add "bind('#{event_name}', #{event_function(options[:prevent_default], &block)})"
        end
        
        #takes away any event listeners on the 'event_name' event fot the selected elements
        def stop_peeping(event_name)
          add "unbind('#{event_name}')"
        end
        
        # triggers the 'event_name' event on the selected elements.
        def trigger(event_name)
          add "trigger('#{event_name}')"
        end





        #-- Drag and Drop --#
        
        # Makes the selected elements draggable. 
        #
        # options can be a hash or a string. The following strings are supported
        #
        # <tt>disable</tt>::  temporarily disables dragging functionality
        # <tt>enable</tt>::   re-enables dragging functionality
        # <tt>destroy</tt>::  disables dragging functionality
        #
        # The options hash has many...well, options, the full list of which
        # can be found here: http://docs.jquery.com/UI/Draggable/draggable#toptions
        # Some usefule ones include:
        #
        # <tt>:opacity</tt>::  opacity of the element once dragging starts
        # <tt>:scroll</tt>::   if true, container auto-scrolls while dragging.
        # <tt>:zIndex</tt>::   z-index for the helper while being dragged.
        # <tt>:helper</tt>::   Possible values: 'original', 'clone'. The 'clone' 
        #                      option will produce the 'ghosting' effect.
        # <tt>:revert</tt>::   if set to true, the element will return to its 
        #                     start position when dragging stops. Also accepts the 
        #                     strings "valid" and "invalid": If set to invalid, revert 
        #                     will only occur if the draggable has not been dropped on
        #                     a droppable. For valid, it's the other way around.
        def draggable(options = nil)
          add "draggable(#{drag_and_drop_options(options)})"
        end
        
        
        # Makes the selected elements droppable. 
        #
        # options can be a hash or a string. The following strings are supported
        #
        # <tt>disable</tt>::  temporarily disables dropping functionality
        # <tt>enable</tt>::   re-enables dropping functionality
        # <tt>destroy</tt>::  disables dropping functionality
        #
        # all options are at http://docs.jquery.com/UI/Droppables/droppable
        # Some useful ones include:
        # <tt>:accept</tt>::   a css selector that defines what type of draggable
        #                     elements it accepts. For instance, if :accept => '.block',
        #                     only draggable objects with the class 'block' will be selected 
        # <tt>:activeClass</tt>::   The class that should be added to the droppable while 
        #                           an acceptable draggable is being dragged.
        # <tt>:hoverClass</tt>::    The class that should be added to the droppable while 
        #                           being hovered by an acceptable draggable.
        # <tt>:tolerance</tt>::     Specifies which mode to use for testing whether a draggable
        #                           is 'over' a droppable. Possible values: 'fit', 'intersect', 
        #                           'pointer', 'touch'. Default value: 'intersect'.
        # <tt>:remote</tt>::        takes a hash of ajax options, the same as given to page.ajax
        #                           if this options is, an ajax call is made using the specified
        #                           options along. Added to the url is an id parameter which
        #                           has the id of the element that was dropped
        # 
        # if a block is given, the blocks code will be executed when a succesful drop is done.
        #
        # Example
        #
        # options = {:accept => '.trash', :remote => {:url => '/stuff'}}
        # page.select('#bucket').droppable options do |p|
        #   p.alert('you dropped it!')
        # end
        #
        # This code will make the element with id 'bucket' droppable. If an element with
        # class 'trash' is dropped onto it, an ajax call to the url '/stuff' will be
        # sent with an id parameter of the id of the dropped element. Then an js alert
        # box with the message 'you dropped it' will appear.
        def droppable(options = nil, &block)
          remote_options = options.delete(:remote)
          if remote_options || block_given?
            func =  Mack::JavaScript::Function.new(session_id, 'ev', 'ui')
            if remote_options
              remote_options[:with] ||= "'id=' + $(ui.draggable).attr('id')"
              func << Mack::JavaScript::ScriptGenerator.new(session_id).ajax(remote_options)
            end
            func.body(&block) if block_given?
            options.merge!(:drop => func)
          end
          add "droppable(#{drag_and_drop_options(options)})"
        end


        private
        
        def build_multiple_selector_string(selector)
          "'#{selector.join(', ')}'"
        end

        def drag_and_drop_options(options)
          options =  options.is_a?(String) ? "'#{options}'" : options_for_effects(options)
        end

        def options_for_effects(options)
          options && !options.empty? ? options_for_javascript(options) : nil
        end

        def optional_selector(selector)
          return "'#{selector}'" if selector
          nil
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
          func << "event.preventDefault()" if prevent_default
          func.body(&block)
        end
        
      end
    end
  end
end
