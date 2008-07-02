class Vtt::ViewTemplateController
  include Mack::Controller
    
  def marge_html_markaby_with_layout
    @last_name = "Simpson"
    render(:action, "marge")
  end
  
  def marge_html_markaby_with_special_layout
    @last_name = "Simpson"
    render(:action, "marge", :layout => "my_cool")
  end
  
  def marge_html_markaby_without_layout
    @last_name = "Simpson"
    render(:action, "marge", :layout => false)
  end
    
end