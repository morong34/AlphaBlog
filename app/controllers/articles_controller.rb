class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:show, :index]
  before_action :require_same_user, only: [:destroy, :edit, :update]
  
  def show
  end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 4)

    if params[:search_by_title]
      @articles = @articles.where("title like ?", 
      "%# {params[:search_by_title]}%")
      if @articles.empty?
        redirect_to articles_path
        flash[:notice] = "Don't exist"
      end
    end
  end 

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(articles_params)
    @article.user = current_user
    if @article.save
      flash[:notice] = "Article was successfully created"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @article.update(articles_params)
      flash[:notice] = "Article was successfully updated"
      redirect_to @article
    else
      render 'edit'
    end
  end
  
  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def articles_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def require_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:alert] = "You do not have the right to edit this article"
      redirect_to @article
    end
  end
end