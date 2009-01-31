class UsersController
  include Mack::Controller
  
  layout :haml_layout
  
  def show
    render(:text, 'Bart Simpson')
  end
  
end