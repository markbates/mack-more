module Mack
  module Javascript
    module Framework
      class Prototype
        @@callbacks = [:uninitialized, :loading, :loaded, :interactive, :complete, :failure, :success ] + 
        [100,101] + (200..206).to_a + (300..307).to_a + (400..417).to_a + (500..505).to_a
        class << self
          def insert_html(position, id, html)
            insertion = position.to_s.camelcase
            "new Insertion.#{insertion}('#{id}', '#{html}')"
          end

          def replace_html(id, html)
            "Element.update('#{id}', '#{html}')"
          end

          def replace(id, html)
            "Element.replace('#{id}', '#{html}')"
          end

          def remove(*ids)
            "#{ids.to_json}.each(Element.remove)"
          end

          def show(*ids)
            "#{ids.to_json}.each(Element.show)"
          end

          def toggle(*ids)
            "#{ids.to_json}.each(Element.toggle)"
          end

          # def draggable(id, options = {})
          #   record @context.send(:draggable_element_js, id, options)
          # end
          # 
          # def visual_effect(name, id = nil, options = {})
          #   record @context.send(:visual_effect, name, id, options)
          # end
          # 
          # def drop_receiving(id, options = {})
          #   record @context.send(:drop_receiving_element_js, id, options)
          # end
          # 
          def remote_function(options)
            javascript_options = options_for_ajax(options)
            "new Ajax.Request('#{options[:url]}', #{javascript_options.to_json})"
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
            elsif options[:submit]
              js_options['parameters'] = "Form.serialize('#{options[:submit]}')"
            elsif options[:with]
              js_options['parameters'] = options[:with]
            end
            options_for_javascript(js_options.reject {|key, value| value.nil?})
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
    end
  end
end