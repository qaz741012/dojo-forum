class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @categories = Category.all

    if params[:category_id]
      @category = Category.includes(:posts).find(params[:category_id])
      if current_user
        @posts = @category.posts.auth_posts(current_user).page(params[:page]).per(20)
        @posts = @category.posts.page(params[:page]).per(20) if current_user.admin?
      else
        @posts = @category.posts.public_posts.page(params[:page]).per(20)
      end
    else
      if current_user
        @posts = Post.auth_posts(current_user).page(params[:page]).per(20)
        @posts = Post.all.page(params[:page]).per(20) if current_user.admin?
      else
        @posts = Post.public_posts.page(params[:page]).per(20)
      end
    end

    case params[:order]
    when "replies_count"
      @posts = @posts.order(replies_count: :desc)
    when "last_replied"
      @posts = @posts.order(last_replied_time: :desc)
    when "viewed_count"
      @posts = @posts.order(viewed_count: :desc)
    end

    @order = params[:order] if params[:order]
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    add_draft = post_params
    add_draft[:draft?] = (params[:commit] == "Save Draft")
    if add_draft[:draft?]
      add_draft[:auth] = "self"
    end

    post = current_user.posts.build(add_draft)
    if post.save
      # save categories
      if post_category_params
        post_category_params[:category_id].each do |category_id|
          post.post_categories.create(category_id: category_id)
        end
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
    if !(@post.auth_user?(current_user) || current_user.admin?)
      flash[:alert] = "You don't have authority to this post."
      redirect_back(fallback_location: root_path)
    end
    @categories = @post.categories
    @replies = Reply.includes(:user).where(post_id: @post.id).page(params[:page]).per(20)

    viewed_count = @post.viewed_count + 1
    @post.update(viewed_count: viewed_count)
  end

  def edit
    @categories = Category.all
    @post = Post.find(params[:id])
    if current_user != @post.user
      flash[:alert] = "You don't have authority to this post."
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    post = Post.find(params[:id])

    add_draft = post_params
    add_draft[:draft?] = (params[:commit] == "Save Draft")
    if add_draft[:draft?]
      add_draft[:auth] = "self"
    end

    if post.update(add_draft)
      # save categories
      post.post_categories.destroy_all
      if post_category_params
        post_category_params[:category_id].each do |category_id|
          post.post_categories.create(category_id: category_id)
        end
      end

      flash[:notice] = "The post was successfully updated!"
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

  def collect
    collect = current_user.collects.build(post_id: params[:id])
    collect.save
    render json: { id: params[:id] }
  end

  def uncollect
    uncollect = current_user.collects.find_by_post_id(params[:id])
    uncollect.destroy
    render json: { id: params[:id] }
  end

  def feeds
    @user_count = User.count
    @post_count = Post.count
    @reply_count = Reply.count

    @chatterboxes = User.order(replies_count: :desc).limit(10)
    @most_popular_posts = Post.auth_posts(current_user).order(replies_count: :desc).limit(10)
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :photo, :auth)
  end

  def post_category_params
    if params[:post_category]
      params.require(:post_category).permit(category_id: [])
    end
  end

end
