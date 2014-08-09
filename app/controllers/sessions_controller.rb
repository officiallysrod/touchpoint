class SessionsController < ApplicationController
  def new
    @user = User.new
    @is_login = true
  end

  def create
    u = User.where(email: params[:user][:email]).first

    if u && u.authenticate(params[:user][:password])
      session[:user_id] = u.id.to_s
      redirect_to user_path(current_user.id)
    else
      redirect_to new_session_path
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end
end
