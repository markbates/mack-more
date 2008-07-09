class UsersController
  include Mack::Controller
  
  def create
    @user = User.create(params[:user])
  end
  
  def update
    @user = User.new(params[:user])
    @user.valid?
    render(:action, :edit)
  end
  
end