class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :fname, type: String
  field :lname, type: String
  field :email, type: String
  field :password_digest, type: String

  has_secure_password

  has_many :contacts
end
