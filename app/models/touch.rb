class Touch
  include Mongoid::Document
  field :description, type: String
  field :kind, type: String
  field :due_date, type: Date
  field :recurrence, type: String
  field :notes, type: String
  field :is_complete, type: Mongoid::Boolean, default: false

  belongs_to :user
  belongs_to :contact

  def make_copy
    new_touch = Touch.new
    new_touch.description = self.description
    new_touch.kind = self.kind
    new_touch.recurrence = self.recurrence
    new_touch.notes = self.notes
    new_touch.user_id = self.user_id
    new_touch.contact_id = self.contact_id


    case self.recurrence
    when "Every Day"
      if self.due_date <= Date.today
        new_touch.due_date = Date.today + 1.day
      elsif self.due_date > Date.today
        new_touch.due_date = self.due_date + 1.day
      end
    when "Every Week"
      new_touch.due_date = self.due_date + 1.week
    when "Every 2 Weeks"
      new_touch.due_date = self.due_date + 2.weeks
    when "Every Month"
      new_touch.due_date = self.due_date + 1.month
    when "Every Year"
      new_touch.due_date = self.due_date + 1.year
    end

    new_touch.save

  end

end
