class UsersController < ApplicationController
  before_action :set_user
  before_action :profile_status, only: [:my_comment, :my_collect, :my_draft, :my_friend]

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
        redirect_to my_post_user_path(@user)
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def my_post
    @posts = @user.posts.where(draft?: false)
    if !current_user.admin?
      @posts = @posts.auth_posts(current_user)
    end
  end

  def my_comment
    @replies = Reply.includes(:post).where( user_id: @user.id)
    if !current_user.admin?
      @replies = Reply.includes(:post).where( user_id: @user.id,
                                              post_id: Post.all.auth_posts(current_user).pluck(:id))
    end
  end

  def my_collect
    if current_user == @user || current_user.admin?
      @collects = Collect.includes(:post).where(user_id: @user.id)
    else
      flash[:alert] = "You don't have the authority."
      redirect_back(fallback_location: root_path)
    end
  end

  def my_draft
    if current_user == @user || current_user.admin?
      @posts = @user.posts.where(draft?: true)
    else
      flash[:alert] = "You don't have the authority."
      redirect_back(fallback_location: root_path)
    end
  end

  def my_friend
    if current_user == @user || current_user.admin?
      @requests = Friendship.includes(:friend).where(user_id: @user.id, status: "request")
      @unconfirms = Friendship.includes(:friend).where(user_id: @user.id, status: "unconfirm")
      @confirms = Friendship.includes(:friend).where(user_id: @user.id, status: "confirm")
    else
      flash[:alert] = "You don't have the authority."
      redirect_back(fallback_location: root_path)
    end
  end

  def add_friend
    if current_user != @user
      friendship1 = current_user.friendships.build( friend_id: params[:id],
                                                    status: "request" )
      if friendship1.save
        flash[:notice] = "Successfully sent request."
        friendship2 = @user.friendships.build( friend_id: current_user.id,
                                               status: "unconfirm" )
        friendship2.save
      else
        flash[:alert] = friendship1.errors.full_messages.to_sentence
      end
    else
      flash[:alert] = "Can't send request to yourself."
    end
    redirect_back(fallback_location: root_path)
  end

  def cancel_request
    friendship = current_user.friendships.find_by_friend_id(params[:id])
    if friendship
      friendship.destroy
      flash[:notice] = "Successfully cancelled the request."
      redirect_back(fallback_location: root_path)
    end
  end

  def confirm_friend
    friendship1 = current_user.friendships.find_by_friend_id(params[:id])
    friendship1.update(status: "confirm")
    friendship2 = @user.friendships.find_by_friend_id(current_user.id)
    friendship2.update(status: "confirm")
    flash[:notice] = "Confirmed the friend."
    redirect_back(fallback_location: root_path)
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
