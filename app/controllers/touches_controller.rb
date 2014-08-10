class TouchesController < ApplicationController
  
  # before_action :verify_user, only: [:index, :show, :edit, :update, :destroy]


  def index
    @contact = Contact.find(params[:contact_id])
    @touches = current_user.Touch.all
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
    touch = Touch.new(params.require(:touch).permit(:contact, :description, :type, :due_date, :recurrence, :notes, :complete?))
    touch.user = current_user

    if touch.save
      redirect_to user_path(current_user.id)
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
    @touch = Touch.where(params[:id])
    @contact = @touch.contact
  end

  def update
    @touch = Touch.find(params[:id])
    if @touch.update_attributes(params.require(:touch).permit(:type, :due_date, :complete?))
      if @touch.complete? == true
        @touch.repeat
      end
      redirect_to user_path(current_user.id)
    else
      render 'edit'
    end
  end

  def destroy
    @contact = Contact.find(params[:contact_id])
    @touch = Touch.find(params[:id])
    @touch.destroy
    redirect_to contact_touches_path
  end

  def repeat
    @touch = Touch.where(params[:id])

    case @touch.recurrence
    when "Never"
      @touch.destroy
    when "Every Day"
      @touch.due_date = Date.today + 1.day
      @touch.update_attributes
    when "Every Week"
      @touch.due_date += 1.week
      @touch.update_attributes
    when "Every 2 Weeks"
      @touch.due_date += 2.weeks
      @touch.update_attributes
    when "Every Month"
      @touch.due_date += 1.month
      @touch.update_attributes
    when "Every Year"
      @touch.due_date += 1.year
      @touch.update_attributes
    end
  end

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
