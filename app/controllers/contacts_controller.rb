class ContactsController < ApplicationController
  
  before_action :verify_user, only: [:index, :edit, :update, :destroy]

  def index
    @contacts = current_user.contacts.all.sort_by!{|c| c.lname}
  end

  def show
    @contact = Contact.find(params[:id])
    if @contact.user == current_user
      @contact
    elsif current_user
      redirect_to contacts_path
    else
      redirect_to new_session_path
    end
  end

  def new
    if current_user
      @contact = Contact.new
    else
      redirect_to new_session_path
    end
  end

  def create
    @contact = current_user.contacts.create(contact_params)

    if @contact.save
      redirect_to user_path(current_user.id)
    else
      render 'new'
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      redirect_to user_path(current_user.id)
    else
      render 'edit'
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to user_path(current_user.id)
  end

private

  def contact_params
    params.require(:contact).permit(:fname, :lname, :spouse, :email, :home_phone, :mobile_phone, :address, :giving_level)
  end

  def verify_user
    @contact = Contact.find(params[:id])
    
    if current_user
      unless @contact.user == current_user
        redirect_to user_path(current_user.id)
      end
    else
      redirect_to root_path
    end
  end
end
