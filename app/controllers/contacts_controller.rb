class ContactsController < ApplicationController
  
  before_action :verify_user, only: [:create, :edit, :update, :destroy]

  def index
    @contacts = Contact.all
    if current_user
      Contact.each do |c|
        if c.user != current_user
          @contacts = @contacts.drop(1)
        end
      @contacts
      end
    else
      redirect_to new_session_path
    end
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

  private

    def verify_user
      @contact = Contact.find(params[:id])
      unless @contact.user == current_user
        redirect_to contacts_path
      end
    end
end
