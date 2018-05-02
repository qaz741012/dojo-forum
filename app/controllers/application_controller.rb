class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_admin!
    if current_user
      if !current_user.admin?
        flash[:alert] = "You don't have authority."
        redirect_to root_path
      end
    end
  end
end
