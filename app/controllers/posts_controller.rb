class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def new
    @categories = Category.all
  end

  def create
    add_draft = post_params
    add_draft[:draft?] = (params[:commit] == "Save Draft")
    post = current_user.posts.build(add_draft)
    if post.save
      # save categories
      # last_post = Post.order(created_at: :desc).first
      post_category_params[:category_id].each do |category_id|
        post.post_categories.create(category_id: category_id)
      end

      flash[:notice] = "The post was successfully created!"
      redirect_to post_path(post)
    else
      flash[:alert] = post.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  def show
    @post = Post.find(params[:id])
    @replies = @post.replies
    @categories = @post.categories
  end

  def edit
    @categories = Category.all
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])

    add_draft = post_params
    add_draft[:draft?] = (params[:commit] == "Save Draft")

    if post.update(add_draft)
      # save categories
      post_category_params[:category_id].each do |category_id|
        post.post_categories.create(category_id: category_id)
      end

      flash[:notice] = "The post was successfully created!"
      redirect_to post_path(post)
    else
      flash[:alert] = post.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "Post was successfully deleted."
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :photo, :auth)
  end

  def post_category_params
    params.require(:post_category).permit(category_id: [])
  end

end
