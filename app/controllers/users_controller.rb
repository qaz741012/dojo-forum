class UsersController < ApplicationController
  before_action :set_user
  before_action :profile_status, except: [:edit, :update, :my_post]

  def show

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

  def my_post
    @posts = @user.posts.where(draft?: false)
  end

  def my_comment
    @replies = Reply.includes(:post).where(user_id: @user.id)
  end

  def my_collect
    #code
  end

  def my_draft
    #code
  end

  def my_friend
    #code
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :avatar)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def profile_status
    @status = params[:status]
  end

end
