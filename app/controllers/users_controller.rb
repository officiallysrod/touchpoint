class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @is_signup = true
  end

  def create
    @user = User.new(params.require(:user).permit(:fname, :lname, :email, :password, :password_confirmation))
    
    if @user.save
      redirect_to new_user_path
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params.require(:user).permit(:fname, :lname, :email))
      redirect_to new_user_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end
end
