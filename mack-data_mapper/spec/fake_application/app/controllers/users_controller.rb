class UsersController
  include Mack::Controller
  
  def create
    @user = User.new(params[:user])
    @user.valid?
  end
  
end