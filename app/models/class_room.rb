class ClassRoom < ApplicationRecord
  has_many :students
  has_and_belongs_to_many :courses

  def as_json(options = {})
	h = super(options)
	# h[:checked] = false
	h[:checked_id] = courses.map(&:id)
	h
  end
end