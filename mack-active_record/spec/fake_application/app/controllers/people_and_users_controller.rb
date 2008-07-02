class PeopleAndUsersController
  include Mack::Controller
  
  def create
    @user = User.create(params[:user])
    @person = Person.create(params[:person])
  end
  
end