class OutingsController < ApplicationController
  before_action :require_logged_in

  def new
    @outing = Outing.new # Instantiate a new outing object for the form_for on the new page

    @user = User.find(session[:user_id])
  end

  def create
    @outing = Outing.new(outing_params)

    @user = User.find(params[:outing][:user_id])

    @outing.users << @user

    @outing.save

    redirect_to invite_path(@outing)
  end

  def show
    @outing = Outing.find(params[:id])

    @user = User.find(session[:user_id])

    if session[@user.username][@outing.id.to_s]
      redirect_to invite_path(@outing) if session[@user.username][@outing.id.to_s] == "invite"
      redirect_to suggest_path(@outing) if session[@user.username][@outing.id.to_s] == "suggest"    
    else
      redirect_to invite_path(@outing)
    end
  end

  def invite
    @outing = Outing.find(params[:id])

    # Filters out the current user and creates a list of users for the show page
    
    # @users = User.all.select {|user| user.id != session[:user_id]}

    @users = User.all.select {|user| !@outing.users.include?(user)}

    @user = User.find(session[:user_id])

    # Creates the cookie hash if it doesn't already exist
    session[@user.username] ||= {}

    # Creates a hash that records the state for each user's outings so it knows if the user already
    # submitted, voted, or if the user is viewing voting results

    # This only sets the outing_id state to submissions if that cookie hasn't already been set up
    session[@user.username][@outing.id] ||= "invite"
  end

  def suggest
    @outing = Outing.find(params[:id])

    @user_suggestions = @outing.suggestions.select{|suggestion| suggestion.user.id == session[:user_id] }

    @suggestion = @outing.suggestions.build

  end

  def post_suggestion
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion.user = User.find(session[:user_id])

    @outing = Outing.find(params[:id])

    @suggestion.outing = @outing

    @outing.suggestions << @suggestion

    @suggestion.save

    @outing.save
    
    redirect_to suggest_path(@outing)
  end

  def submit_suggestions
    @outing = Outing.find(params[:id])

    @user = User.find(session[:user_id])

    session[@user.username][@outing.id] = "vote"

    redirect_to outing_path(@outing)
  end

  def send_invites
    # Assigns the users chosen to the outing
    @outing = Outing.find(params[:id])

    @outing.user_ids = params[:outing][:user_ids]

    @user = User.find(session[:user_id])

    @outing.users << @user

    @outing.save

    session[@user.username][@outing.id] = "suggest"

    redirect_to outing_path(@outing)
  end

  private

  def outing_params
    params.require(:outing).permit(:name, :event_start, :voting_deadline)
  end

  def suggestion_params
    params.require(:suggestion).permit(:name, :address, :specific)
  end
end
