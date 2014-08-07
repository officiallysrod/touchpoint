class ContactsController < ApplicationController
  def index
    @contacts = Contact.all
  end

  def show
  end

  def new
  end

  def create
    current_user.contacts.create(params.require(contact).permit(:fname, :lname, :spouse, :email, :home_phone, :mobile_phone, :address, :twitter, :giving_level))
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
