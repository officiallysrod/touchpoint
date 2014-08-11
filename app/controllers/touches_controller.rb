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
    @touch = Touch.new(params.require(:touch).permit(:contact, :description, :kind, :due_date, :recurrence, :notes, :complete?))
    @touch.user = current_user
    
    if @touch.save
      redirect_to user_path(current_user.id)
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    @touch = @user.touches.where(:_id => params[:id]).first
    @contact = @touch.contact
    @contacts = current_user.contacts.all.sort_by!{|c| c.lname}
    # @contact = Contact.where(params[:id])
  end

  def update
    @touch = Touch.where(params[:id])
    if @touch.update_attributes(params.require(:touch).permit(:kind, :due_date, :complete?))
      if @touch.complete? == true
        @touch.repeat
      end
      redirect_to user_path(current_user.id)
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user
    # @contact = Contact.find(params[:contact_id])
    @touch = Touch.find(params[:id])
    @touch.destroy
    redirect_to user_path(current_user.id)
  end

  # def repeat
  #   @touch = Touch.where(params[:id])

  #   case @touch.recurrence
  #   when "Never"
  #     @touch.destroy
  #   when "Every Day"
  #     @touch.due_date = Date.today + 1.day
  #     @touch.update_attributes
  #   when "Every Week"
  #     @touch.due_date += 1.week
  #     @touch.update_attributes
  #   when "Every 2 Weeks"
  #     @touch.due_date += 2.weeks
  #     @touch.update_attributes
  #   when "Every Month"
  #     @touch.due_date += 1.month
  #     @touch.update_attributes
  #   when "Every Year"
  #     @touch.due_date += 1.year
  #     @touch.update_attributes
  #   end
  # end

  private

    def verify_user
      if current_user
        @user = User.where(params[:id])
        unless @user == current_user
          redirect_to user_path(current_user.id)
        end
      else
        redirect_to new_session_path
      end
    end

    # def verify_user
    #   @contact = Contact.find(params[:contact_id])
    #   unless @contact.user == current_user
    #     redirect_to contacts_path
    #   end
    # end

end
