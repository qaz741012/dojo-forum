class Admin::UsersController < Admin::BaseController

  def index
    @users = User.page(params[:page]).per(10)
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      flash[:notice] = "User's role was successfully updated."
    else
      flash[:alert] = user.errors.full_messages.to_sentence
    end
    redirect_to admin_root_path
  end


  private

  def user_params
    params.require(:user).permit(:role)
  end

end
