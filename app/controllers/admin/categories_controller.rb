class Admin::CategoriesController < Admin::BaseController

  def index
    @categories = Category.all

    if params[:id]
      @category = Category.find(params[:id])
    else
      @category = Category.new
    end
  end

  def create
    category = Category.new(category_params)
    if category.save(category_params)
      flash[:notice] = "Category was successfully created."
    else
      flash[:alert] = category.errors.full_messages.to_sentence
    end
    redirect_to admin_categories_path
  end

  def update
    category = Category.find(params[:id])
    if category.update(category_params)
      flash[:notice] = "Category was successfully updated."
    else
      flash[:alert] = category.errors.full_messages.to_sentence
    end
    redirect_to admin_categories_path
  end

  def destroy
    category = Category.find(params[:id])
    if category.destroy
      flash[:notice] = "Category was successfully deleted."
    else
      flash[:alert] = category.errors.full_messages.to_sentence
    end
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

end
