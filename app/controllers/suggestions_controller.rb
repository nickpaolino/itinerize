class SuggestionsController < ApplicationController
  def update
    @suggestion = Suggestion.find(params[:id])
    if params[:commit] == "+"
      @outing = Outing.find(params[:suggestion][:outing_id])
      return redirect_to vote_path(@outing) if params[:suggestion][:remaining_likes].to_i < 1
      like = @suggestion.likes.build(suggestion_id: @suggestion.id, user_id: session[:user_id])
      like.save
    end
    if params[:commit] == "-"
      user_likes = @suggestion.likes.select {|like| like.user.id == session[:user_id]}
      user_likes.last.delete if user_likes.count > 0
    end
    redirect_to outing_path(@suggestion.outing)
  end
end
