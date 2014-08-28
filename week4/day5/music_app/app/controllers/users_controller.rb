class UsersController < ApplicationController
  
  before_action :require_signed_out!, only: [:new, :create]
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in!(@user)
      redirect_to user_url(@user)
    else
      render :new
    end
  end
  
  def show
    @user = User.find_by_id(params[:id])
    render :show
  end
  
  def user_params
    params.require(:user).permit(:email, :password)
  end
end
