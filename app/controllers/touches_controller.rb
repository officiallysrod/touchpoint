class TouchesController < ApplicationController
  
  # before_action :verify_user, only: [:index, :show, :edit, :update, :destroy]

  def index
    @contact = Contact.find(params[:contact_id])
    @touches = @contact.touches.all
  end

  def show
    @touch = Touch.find(params[:id])
  end

  def new
    if current_user
      @user = current_user
      @contacts = current_user.contacts.all.sort_by!{|c| c.lname}
      @touch = Touch.new
    else
      redirect_to new_session_path
    end
  end

  def create
    @user = current_user
    @contacts = current_user.contacts.all.sort_by!{|c| c.lname}
    @touch = Touch.new(touch_params)
    @touch.user = current_user
    
    if @touch.save
      redirect_to user_path(current_user.id)
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    @touch = @user.touches.where(_id: params[:id]).first
    @contact = @touch.contact
    @contacts = current_user.contacts.all.sort_by!{|c| c.lname}
  end

  def update
    @user = current_user
    @touch = @user.touches.where(_id: params[:id]).first
    @contacts = current_user.contacts.all.sort_by!{|c| c.lname}

    if @touch.update_attributes(touch_params)
      @touch.make_copy if @touch.is_complete && @touch.recurrence != "Never"
      redirect_to user_path(current_user.id)
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user
    @touch = Touch.find(params[:id])
    @touch.destroy
    redirect_to user_path(current_user.id)
  end

  def mark_complete
    @user = current_user
    @touch = @user.touches.where(_id: params[:id]).first
    @touch.is_complete = true
    if @touch.update_attributes
      @touch.make_copy if @touch.is_complete && @touch.recurrence != "Never"
      redirect_to user_path(current_user.id)
    else
      redirect_to :back
    end
  end

private

  def touch_params
    params.require(:touch).permit(:contact, :description, :due_date, :recurrence, :notes, :is_complete)
  end

  def verify_user
    if current_user
      @user = User.where(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user.id)
      end
    else
      redirect_to root_path
    end
  end

  # def verify_user
  #   @contact = Contact.find(params[:contact_id])
  #   unless @contact.user == current_user
  #     redirect_to contacts_path
  #   end
  # end

end
