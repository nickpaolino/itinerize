class WelcomeController < ApplicationController
  before_action :require_logged_in

  def home
    # This will take us to the landing page for logged in users
  end
end
