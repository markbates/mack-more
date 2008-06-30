class PeopleAndUsersController < Mack::Controller::Base
  
  def create
    @user = User.create(params[:user])
    @person = Person.create(params[:person])
  end
  
end