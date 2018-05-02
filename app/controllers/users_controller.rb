class UsersController < ApplicationController
  before_action :set_user

  def show
    @posts = @user.posts.where(draft?: false)
    @replies = @user.replies
    @drafts = @user.posts.where(draft?: true)
  end

  def edit
    #code
  end

  def update
    #code
  end

  private

  def user_params
    #code
  end

  def set_user
    @user = User.find(params[:id])
  end

end
