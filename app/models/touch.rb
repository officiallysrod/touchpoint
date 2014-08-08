class Touch
  include Mongoid::Document
  field :type, type: String
  field :due_date, type: Date
  field :complete?, type: Mongoid::Boolean, default: false

  belongs_to :contact
end
