class RepliesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    reply = post.replies.build(reply_params)
    reply.user_id = current_user.id

    if post.auth_user?(current_user)
      if reply.save
        post.update(last_replied_time: reply.created_at)
        flash[:notice] = "Comment was successfully replied."
      else
        flash[:alert] = reply.errors.full_messages.to_sentence
      end
    else
      flash[:alert] = "You don't have authority to this post."
    end
    redirect_back(fallback_location: root_path)
  end

  def edit
    @reply = Reply.find(params[:id])
    if current_user != @reply.user
      flash[:alert] = "You don't have authority to this post."
      redirect_back(fallback_location: root_path)
    end

    render json: { id: @reply.id,
                   comment: @reply.comment }
  end

  def update
    post = Post.find(params[:post_id])
    reply = Reply.find(params[:id])

    if post.auth_user?(current_user)
      if reply.update(reply_params)
        post.update(last_replied_time: reply.updated_at)
        flash[:notice] = "Comment was successfully updated."
        redirect_to post_path(reply.post)
      else
        flash[:alert] = reply.errors.full_messages.to_sentence
        redirect_back(fallback_location: root_path)
      end
    else
      flash[:alert] = "You don't have authority to this post."
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    reply = Reply.find(params[:id])
    if current_user != reply.user
      flash[:alert] = "You don't have authority to this post."
    else
      reply.destroy
      flash[:notice] = "Comment was successfully deleted."
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def reply_params
    params.require(:reply).permit(:comment)
  end

end
