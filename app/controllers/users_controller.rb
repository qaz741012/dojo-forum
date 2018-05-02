class UsersController < ApplicationController
  before_action :set_user

  def show
    @posts = @user.posts.where(draft?: false)
    @replies = @user.replies
    @drafts = @user.posts.where(draft?: true)
  end

  def edit
    if @user != current_user
      flash[:alert] = "You are not allow to edit profile of the other users"
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @user == current_user
      if @user.update(user_params)
        flash[:notice] = "Profile was successfully updated."
        redirect_to user_path(@user)
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :avatar)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
