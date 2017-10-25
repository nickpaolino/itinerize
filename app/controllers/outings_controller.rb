class OutingsController < ApplicationController
  before_action :require_logged_in
  before_action :redirect_user_to_profile
  skip_before_action :redirect_user_to_profile, only: [:new, :index, :create]
  before_action :create_user_session

  def new
    @outing = Outing.new # Instantiate a new outing object for the form_for on the new page

    @user = current_user
  end

  def create
    @outing = Outing.new(outing_params)

    @outing.users << current_user

    @outing.save

    redirect_to outing_path(@outing) # Redirects to the outing show page
  end

  def show
    check_if_voting_is_over

    case current_stage
    when "invite"
      redirect_to invite_path(current_outing)
    when "suggest"
      redirect_to suggest_path(current_outing)
    when "vote"
      redirect_to vote_path(current_outing)
    when "result"
      redirect_to result_path(current_outing)
    else
      # This means that the user has just created their outing and so their user_session is blank
      redirect_to invite_path(current_outing)
    end
  end

  def invite
    redirect_if_voting_over

    @outing = current_outing

    # Filters out the current user and all users already part of the outing and creates a list of users for the show page
    @users = User.all.select {|user| !@outing.users.include?(user)}

    # This only sets the outing_id state to invite if that cookie hasn't already been set up
    session[current_user.username][@outing.id] ||= "invite"
  end

  def send_invites
    # Assigns the users chosen to the outing
    users = params[:outing][:user_ids].map {|user_id| User.find(user_id)}

    users.each do |user|
      current_outing.users << user
    end

    current_outing.save

    set_session("suggest")

    redirect_to outing_path(current_outing)

  end

  def suggest
    redirect_if_voting_over

    @outing = current_outing

    set_session("suggest")

    @user_suggestions = @outing.suggestions.select{|suggestion| suggestion.user.id == session[:user_id] }

    @suggestion = @outing.suggestions.build
  end

  def post_suggestion
    suggestion = Suggestion.new(suggestion_params)

    suggestion.user = current_user

    current_outing.suggestions << suggestion

    suggestion.save

    current_outing.save

    redirect_to suggest_path(current_outing)
  end

  def submit_suggestions
    set_session("vote")

    redirect_to outing_path(current_outing)
  end

  def vote
    redirect_if_voting_over

    @outing = current_outing
    @suggestions = @outing.suggestions

    # Sets the user's likes
    @user_likes = Like.all.select {|like| like.user.id == session[:user_id]}

    @total_suggestions = @outing.suggestions.count

    used_likes = current_user.likes.select{ |like| like.suggestion.outing == @outing}.count

    @remaining_likes = @total_suggestions - used_likes
  end

  def result
    @outing = current_outing
    # Takes the top three suggestions with the highest like count
    @top_suggestions = @outing.suggestions.sort_by {|suggestion| suggestion.likes.count}.reverse[0..2]
    # results page
    @likes_hash = {}
    @top_suggestions.each do |suggestion|
      @likes_hash[suggestion.name] ||= {}

      suggestion.likes.each do |like|
        @likes_hash[suggestion.name][like.user.username] ||= 0
        @likes_hash[suggestion.name][like.user.username] += 1
      end

    end
  end

  def redirect_user_to_profile
    return redirect_to user_path(current_user) if !current_outing.users.include?(current_user)
  end

  def index
    # outings index redirects to the user show page
    redirect_to user_path(current_user)
  end

  private

  def outing_params
    params.require(:outing).permit(:name, :event_start, :voting_deadline)
  end

  def suggestion_params
    params.require(:suggestion).permit(:name, :address, :specific)
  end

  def current_user
    User.find(session[:user_id])
  end

  def current_outing
    Outing.find(params[:id])
  end

  def create_user_session
    # Creates a hash that records the state for each user's outings so it knows if the user already
    # submitted, voted, or if the user is viewing voting results
    session[current_user.username] ||= {}
  end

  def set_session(stage)
    session[current_user.username][current_outing.id] = stage
  end

  def session_exists?
    session[current_user.username]
  end

  def current_stage
    session[current_user.username][current_outing.id.to_s]
  end

  def current_session?(stage)
    session[current_user.username][current_outing.id.to_s] == stage
  end

  def check_if_voting_is_over # Sets the user's outing session to result if the voting is over
    if current_outing.voting_over?
      session[current_user.username][current_outing.id.to_s] = "result"
    end
  end

  def redirect_if_voting_over
    check_if_voting_is_over

    redirect_to result_path(@outing) if current_session?("result")
  end
end
