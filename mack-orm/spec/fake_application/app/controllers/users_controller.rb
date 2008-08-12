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
  
  def model_text_field_test
    @user = User.new(:username => "markbates")
  end
  
  def model_password_field_test
    @user = User.new(:username => "markbates")
  end
  
  def model_textarea_test
    @user = User.new(:username => "markbates")
  end
  
end