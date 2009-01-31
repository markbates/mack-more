class Vtt::ViewTemplateController
  include Mack::Controller
  
  def maggie_html_haml_with_layout
    @last_name = "Simpson"
    render(:action, "maggie")
  end
  
  def maggie_html_haml_with_special_layout
    @last_name = "Simpson"
    render(:action, "maggie", :layout => "my_cool")
  end
  
  def maggie_html_haml_without_layout
    @last_name = "Simpson"
    render(:action, "maggie", :layout => false)
  end
  
  def maggie_html_haml_with_haml_layout
    @last_name = "Simpson"
    render(:action, "maggie", :layout => 'haml_layout')
  end

end