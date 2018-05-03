class Admin::CategoriesController < Admin::BaseController

  def index
    @categories = Category.all
    @category = Category.new
  end

end
