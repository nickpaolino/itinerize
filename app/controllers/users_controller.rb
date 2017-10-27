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

    # Gets the list of outings by those most recently created
    @user_finished_outings = @user.outings.select {|outing| outing.voting_over?}.sort_by {|outing| outing.created_at }.reverse
    @user_active_outings = @user.outings.select {|outing| !outing.voting_over?}.sort_by {|outing| outing.created_at }.reverse
  end

  def suggestions
    @user = User.find(params[:id])

    @current_user = User.find(session[:user_id])

    @user_suggestions = @user.suggestions.map {|n| n.name}.uniq

    if @user.id == @current_user.id
      @pronoun = "Your"
    else
      @pronoun = "#{@user.username}'s".capitalize
    end

    @empty_suggestions = @user.suggestions.empty?
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
