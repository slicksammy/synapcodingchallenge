class League < ActiveRecord::Base
  belongs_to :event
  has_many :leagues_people
  has_many :people, through: :leagues_people

  scope :for_event, ->(event) { where(event: event) }
end
