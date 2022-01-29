class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :edit]

  def show 
    @articles = @user.articles.paginate(page: params[:page], per_page: 4)
  end

  def new
    @user = User.new
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 4)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username} to Alpha Blog"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account has been updated"
      redirect_to user_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

end