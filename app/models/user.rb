class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :email, type: String
  field :fname, type: String
  field :lname, type: String
  field :password_digest, type: String

  has_secure_password

  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :fname
  validates_presence_of :lname
  

  has_many :contacts
  has_many :touches
end
