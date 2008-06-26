class Vtt::ViewTemplateController < Mack::Controller::Base
  
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

end