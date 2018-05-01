class PostsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    #code
  end

  def edit
    #code
  end

  def update
    #code
  end
end
