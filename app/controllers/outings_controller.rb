class OutingsController < ApplicationController
  before_action :require_logged_in

  def new
    @outing = Outing.new # Instantiate a new outing object for the form_for on the new page

    @user = User.find(session[:user_id])
  end

  def create
    @outing = Outing.new(outing_params)

    user = User.find(params[:outing][:user_id])

    @outing.users << user

    @outing.save

    redirect_to invite_path(@outing)
  end

  def invite
    @outing = Outing.find(params[:id])

    # Filters out the current user and creates a list of users for the show page
    @users = User.all.select {|user| user.id != session[:user_id]}
    # @users = User.all.select {|user| user.id != session[:user_id]}.map {|user| [user.username, user.id]}

    @user = User.find(session[:user_id])

    # Creates the cookie hash if it doesn't already exist
    session[:user_states] ||= {}

    # Creates a hash that records the state for each user's outings so it knows if the user already
    # submitted, voted, or if the user is viewing voting results

    # This only sets the outing_id state to submissions if that cookie hasn't already been set up
    session[:user_states][@outing.id] ||= "invite"
  end

  def send_invites
    # Assigns the users chosen to the outing
    @outing = Outing.find(params[:id])

    @outing.user_ids = params[:outing][:user_ids]

    user = User.find(session[:user_id])

    @outing.users << user

    @outing.save

    session[:user_states][@outing.id] = "suggest"

    redirect_to outing_path(@outing)
  end

  def show
    @outing = Outing.find(params[:id])

    redirect_to invite_path(@outing) if session[:user_states][@outing.id.to_s] == "invite"
    render :show if session[:user_states][@outing.id.to_s] == "suggest"
  end

  private

  def outing_params
    params.require(:outing).permit(:name, :event_start, :voting_deadline)
  end
end
