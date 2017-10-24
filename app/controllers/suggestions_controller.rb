class SuggestionsController < ApplicationController
    def update
        @suggestion = Suggestion.find(params[:id])
        if params[:commit] == "+"
            like = @suggestion.likes.build(suggestion_id: @suggestion.id, user_id: session[:user_id])
            like.save
        end
        if params[:commit] == "-"
            user_likes = @suggestion.likes {|like| like.user == session[:user_id]}
            user_likes.last.delete if user_likes.count > 0
        end

        redirect_to outing_path(@suggestion.outing)
    end
end
