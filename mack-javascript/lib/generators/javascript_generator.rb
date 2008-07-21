puts "In js_mack_app_generator.rb"
# This will generate required RJS support in your application.
# 
# example: 
#    rake generate:javascript
#
class JavascriptGenerator  < Genosaurus
    
  def setup
    error = %{no js_framework specified in app_config}
    raise error unless app_config.mack.js_framework
  end
  
  def js_framework # :nodoc:
    app_config.mack.js_framework
  end
  
end