class Contact
  include Mongoid::Document
  field :fname, type: String
  field :lname, type: String
  field :spouse, type: String
  field :email, type: String
  field :home_phone, type: String
  field :mobile_phone, type: String
  field :address, type: String
  field :giving_level, type: String

  belongs_to :user
  has_many :touches

  validates_presence_of :fname
  validates_presence_of :lname
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create

  before_save { self.fname = fname.titleize }
  before_save { self.lname = lname.titleize }
  before_save { self.spouse = spouse.titleize }
  before_save { self.email = email.downcase }

  def full_name
    "#{fname} #{lname}"
  end

  def lname_fname
    "#{lname}, #{fname}"
  end

end
