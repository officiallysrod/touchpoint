class Touch
  include Mongoid::Document
  field :description, type: String
  field :type, type: String
  field :due_date, type: Date
  field :recurrence, type: String
  field :notes, type: String
  field :complete?, type: Mongoid::Boolean, default: false

  belongs_to :user
  belongs_to :contact
  
end
