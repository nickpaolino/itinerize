class OutingsController < ApplicationController
  before_action :require_logged_in

  def new
    @outing = Outing.new # Instantiate a new outing object for the form_for on the new page

    @user = User.find(session[:user_id])
  end

  def create
    @outing = Outing.new(outing_params)

    @outing.save

    redirect_to outing_path(@outing)
  end

  def show
    @outing = Outing.find(params[:id])

    @user = User.find(session[:user_id])

    # Filters out the current user and creates a list of users for the create new outing page
    @users = User.all.select {|user| user.id != session[:user_id]}.map {|user| [user.username, user.id]}
  end

  private

  def outing_params
    params.require(:outing).permit(:name, :event_start, :voting_deadline)
  end
end
