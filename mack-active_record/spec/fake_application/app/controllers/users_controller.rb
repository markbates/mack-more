class UsersController < Mack::Controller::Base
  
  def create
    @user = User.create(params(:user))
  end
  
end