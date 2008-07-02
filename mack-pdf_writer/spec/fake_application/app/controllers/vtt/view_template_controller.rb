class Vtt::ViewTemplateController
  include Mack::Controller
    
  def hello_pdf
    render(:action, "hello")
  end

end