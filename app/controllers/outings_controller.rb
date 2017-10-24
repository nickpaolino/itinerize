class OutingsController < ApplicationController
  before_action :require_logged_in

  def new
    @outing = Outing.new # Instantiate a new outing object for the form_for on the new page
  end

  def create
    
  end

  def show
    @user = User.find(session[:user_id])

    # Filters out the current user and creates a list of users for the create new outing page
    @users = User.all.select {|user| user.id != session[:user_id]}.map {|user| [user.username, user.id]}
  end
end
