class Teacher < ApplicationRecord
  has_one :user, as: :owner
  has_and_belongs_to_many :courses

  def as_json(options = {})
	h = super(options)	
	h[:checked_id]=courses.map(&:id)
	h
  end
end