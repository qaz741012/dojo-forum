class Admin::UsersController < Admin::BaseController

  def index
    @users = User.page(params[:page]).per(10)
  end

  def edit
    #code
  end

  def update
    #code
  end

end
