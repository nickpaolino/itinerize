class UsersController < ApplicationController

  def new

  end

  def create
    @user = User.create(user_params)
    return redirect_to controller: 'users', action: 'new' unless @user.save
    session[:user_id] = @user.id
    redirect_to controller: 'users', action: 'show'
  end

  def show # This is the first page a logged in user sees
    # It's essentially the user profile page
    require_logged_in # Requires that the users logged in
    
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
