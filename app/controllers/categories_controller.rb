class CategoriesController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def new
    @category = Category.new
  end

  def create 
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category was successfully created"
      redirect_to category_path(@category)
    else
      render 'new'
    end
  end

  def index 
    @categories = Category.paginate(page: params[:page], per_page: 4)
  end

  def show
    @articles = @category.articles.paginate(page: params[:page], per_page:5)
  end 

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category was successfully updated"
      redirect_to @category
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    if !current_user.admin?
      flash[:alert] = "You do not have the right to edit or to delete this category"
      redirect_to category_path
    end
  end

end