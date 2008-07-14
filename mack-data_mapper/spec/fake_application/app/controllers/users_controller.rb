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
  
  def text_field_test
    @user = User.new(:username => "markbates")
  end
  
  def password_field_test
    @user = User.new(:username => "markbates")
  end
  
  def text_area_test
    @user = User.new(:username => "markbates")
  end
  
end