class ContactsController < ApplicationController
  
  def index
    @contacts = Contact.all
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = current_user.contacts.create(params.require(:contact).permit(:fname, :lname, :spouse, :email, :home_phone, :mobile_phone, :address, :twitter, :giving_level))

    if @contact.save
      redirect_to contacts_path
    else
      render 'new'
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(params.require(:contact).permit(:fname, :lname, :spouse, :email, :home_phone, :mobile_phone, :address, :twitter, :giving_level))
      redirect_to contacts_path
    else
      render 'edit'
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_path
  end
end
