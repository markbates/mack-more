class UsersController
  include Mack::Controller
  
  def create
    @user = User.create(params[:user])
  end
  
end