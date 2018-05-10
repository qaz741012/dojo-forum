class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index

  def index
    if current_user
      @posts = Post.includes(:categories).auth_posts(current_user)
    else
      @posts = Post.includes(:categories).public_posts
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    if !@post
      render json: {
        message: "Can't find the post."
      }, status: 400
    else
      if !@post.auth_user?(current_user)
        render json: {
          message: "You don't have authority to this post."
        }, status: 401
      end
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    @categories = params[:categories][1..-2].split(", ")
    if @post.save
      @categories.each do |category|
        @post.post_categories.create(category_id: category)
      end
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
