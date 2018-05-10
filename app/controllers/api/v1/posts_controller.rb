class Api::V1::PostsController < ApiController

  def index
    @posts = Post.all
    render json: { data: @posts }
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post
      render json: @post
    else
      render json: {
        message: "Can't find the post."
      }, status: 400
    end
  end

end
