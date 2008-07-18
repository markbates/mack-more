class DefaultController
  include Mack::Controller
  
  # /
  def index
  end
  
  def hello_world
    wants(:xml) do
      render(:text, "<name>#{params[:name]}</name><rand>#{rand}</rand>")
    end
    wants(:html) do
      render(:text, "<p>#{params[:name]}</p><p>#{rand}</p>")
    end
  end
  
  def always_500
    render(:text, "i should be 500: #{rand}", :status => 500)
  end

end
