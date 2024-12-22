class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event
  validates :user_id, uniqueness: { scope: :event_id, message: "is already registered for this event" }
end
