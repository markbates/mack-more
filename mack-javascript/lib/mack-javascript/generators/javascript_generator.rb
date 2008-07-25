# This will generate required RJS support in your application.
# 
# example: 
#    rake generate:javascript
#
class JavascriptGenerator  < Genosaurus
    
  def setup
    error = %{  'js_framework' is not specified in your app_config/default.yml file.
      To fix this error, please open your {PROJ}/config/app_config/default.yml file, then uncomment 
      the line that says "# js_framework: jquery" (or prototype, if you specified prototype as the js framework).
      Once you have uncomment that line, please re-run 'rake generate:javascript' again. Thanks!}
    raise error unless app_config.mack.js_framework
  end
  
  def js_framework # :nodoc:
    app_config.mack.js_framework
  end
  
end