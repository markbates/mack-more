class UsersController
  include Mack::Controller
  
  def create
    @user = User.new(params[:user])
    @user.valid?
  end
  
  def update
    @user = User.new(params[:user])
    @user.valid?
    render(:action, :edit)
  end
  
end