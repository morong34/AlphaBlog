class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  
  def show
  end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 4)
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
    params.require(:article).permit(:title, :description)
  end
end