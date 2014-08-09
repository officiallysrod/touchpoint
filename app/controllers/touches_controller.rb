class TouchesController < ApplicationController
  
  before_action :verify_user, only: [:index, :show, :edit, :update, :destroy]


  def index
    @contact = Contact.find(params[:contact_id])
    @touches = Touch.all
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
    @touch = Touch.find(params[:id])
    @contact = @touch.contact
  end

  def update
    @touch = Touch.find(params[:id])
    if @touch.update_attributes(params.require(:touch).permit(:type, :due_date, :complete?))
      redirect_to contact_touches_path
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
