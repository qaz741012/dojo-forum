class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @categories = Category.all

    if params[:category_id]
      @category = Category.includes(:posts).find(params[:category_id])
      if current_user
        @posts = @category.posts.auth_posts(current_user).page(params[:page]).per(10)
      else
        @posts = @category.posts.public_posts.page(params[:page]).per(10)
      end
    else
      if current_user
        @posts = Post.auth_posts(current_user).page(params[:page])
      else
        @posts = Post.public_posts.page(params[:page]).per(10)
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
    @categories = Category.all
  end

  def create
    add_draft = post_params
    add_draft[:draft?] = (params[:commit] == "Save Draft")
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
    @post = Post.includes(replies: :user).find(params[:id])
    @categories = @post.categories

    viewed_count = @post.viewed_count + 1
    @post.update(viewed_count: viewed_count)
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
    if collect.save
      flash[:notice] = "The post was successfully collected."
    else
      flash[:alert] = collect.errors.full_messages.to_sentence
    end
    redirect_back(fallback_location: root_path)
  end

  def uncollect
    uncollect = current_user.collects.find_by_post_id(params[:id])
    if uncollect
      uncollect.destroy
      flash[:notice] = "The post was successfully uncollected."
    else
      flash[:alert] = "The post was haven't been collected."
    end
    redirect_back(fallback_location: root_path)
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
