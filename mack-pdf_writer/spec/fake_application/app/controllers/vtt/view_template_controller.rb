class Vtt::ViewTemplateController < Mack::Controller::Base
    
  def hello_pdf
    render(:action, "hello")
  end

end