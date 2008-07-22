class Vtt::ViewTemplateController
  include Mack::Controller
    
  def bleeding_gums_murphy_with_render
    @bleeding = true if params[:bleeding]
    render(:js, "bleeding_gums_murphy")
  end
  
  def bleeding_gums_murphy
    @bleeding = true if params[:bleeding]
  end
  

    
end