class UsersController < Mack::Controller::Base
  
  def create
    @user = User.new(params(:user))
    @user.valid?
  end
  
end