class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index

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

  def create
    @post = Post.new(post_params)
    if @post.save
      render json: {
        message: "Post was successfully created.",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.update(post_params)
      render json: {
        message: "Post was successfully updated.",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    render json: {
      message: "Post was successfully deleted."
    }
  end

  private

  def post_params
    params.permit(:title, :content, :photo, :auth, :draft?)
  end

end
