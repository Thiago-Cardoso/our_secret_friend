class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #before_action :authenticate_user!
  #added return 404 not found
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

    def render_404
      redirect_to main_app.root_url
    end
end
