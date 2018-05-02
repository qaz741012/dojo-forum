class RepliesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    reply = post.replies.build(reply_params)
    reply.user_id = current_user.id

    if reply.save
      flash[:notice] = "Comment was successfully replied."
    else
      flash[:alert] = reply.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: root_path)
  end

  def edit
    @reply = Reply.find(params[:id])
  end

  def update
    reply = Reply.find(params[:id])
    if reply.update(reply_params)
      flash[:notice] = "Comment was successfully updated."
      redirect_to post_path(reply.post)
    else
      flash[:alert] = reply.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end

  end

  def destroy
    #code
  end

  private

  def reply_params
    params.require(:reply).permit(:comment)
  end

end
