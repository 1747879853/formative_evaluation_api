class Course < ApplicationRecord
  has_and_belongs_to_many :class_rooms
  has_and_belongs_to_many :evaluations
  has_and_belongs_to_many :teachers

  def as_json(options = {})
	h = super(options)	
	h[:title] = self.name
	h[:checked] = false
	h[:checked_id] = evaluations.map(&:id)
	h
  end
end