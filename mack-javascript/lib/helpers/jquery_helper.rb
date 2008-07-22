module Mack
  module JavaScript
    module Framework
      class Jquery      
        class << self
          def insert_html(position, id, html)
            insertion = position.to_s.downcase
            insertion = 'append' if insertion == 'bottom'
            insertion = 'prepend' if insertion == 'top'
            "$(\"##{id}\").#{insertion}('#{html}')"
          end

          def replace_html(id, html)
            insert_html(:html, id, html)
          end

          def replace(id, html)
            "$(\"##{id}\").replaceWith('#{html}')"
          end

          def remove(*ids)
            "$(\"##{ids.join(',#')}\").remove()"
          end

          def show(*ids)
            "$(\"##{ids.join(',#')}\").show()"
          end

          def hide(*ids)
            "$(\"##{ids.join(',#')}\").hide()"
          end

          def toggle(*ids)
            "$(\"##{ids.join(',#')}\").toggle()"
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
            update = ''
            if options[:update] && options[:update].is_a?(Hash)
              update  = []
              update << "success:'#{options[:update][:success]}'" if options[:update][:success]
              update << "failure:'#{options[:update][:failure]}'" if options[:update][:failure]
              update  = '{' + update.join(',') + '}'
            elsif options[:update]
              update << "'#{options[:update]}'"
            end

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
            js_options['type'] = options[:method] ? "'#{options[:method]}'" : "'post'"
            js_options['dataType'] = options[:datatype] ? "'#{options[:datatype]}'" : (options[:update] ? nil : "'script'")

            if options[:form]
              js_options['data'] = "$.param($(this).serializeArray())"
            elsif options[:submit]
              js_options['data'] = "$(\"##{options[:submit]}\").serializeArray()"
            elsif options[:with]
              js_options['data'] = options[:with].gsub('Form.serialize(this.form)','$.param($(this.form).serializeArray())')
            end
            options_for_javascript(js_options.reject {|key, value| value.nil?})
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
    end
  end
end
