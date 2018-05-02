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


  private

  def reply_params
    params.require(:reply).permit(:comment)
  end

end
