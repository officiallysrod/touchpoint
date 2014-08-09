class TouchesController < ApplicationController
  
  before_action :verify_user, only: [:index, :show, :new, :create, :edit, :update, :destroy]


  def index
    @contact = Contact.find(params[:contact_id])
    @touches = Touch.all
  end

  def show
    @contact = Contact.find(params[:contact_id])
    @touch = Touch.find(params[:id])
  end

  def new
    @contact = Contact.find(params[:contact_id])
    @user = current_user
    @touch = Touch.new
  end

  def create
    @contact = Contact.find(params[:contact_id])
    touch = Touch.new(params.require(:touch).permit(:description, :type, :due_date, :recurrence, :notes, :complete?))
    touch.contact = @contact
    touch.user = current_user

    if touch.save
      redirect_to contact_touches_path(@contact.id)
    else
      render 'new'
    end
  end

  def edit
    @contact = Contact.find(params[:contact_id])
    @touch = Touch.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:contact_id])
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
      @contact = Contact.find(params[:contact_id])
      unless @contact.user == current_user
        redirect_to contacts_path
      end
    end

end
