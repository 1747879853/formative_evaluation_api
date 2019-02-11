class Evaluation < ApplicationRecord
  has_and_belongs_to_many :courses

  def as_json(options = {})
	h = super(options)
	h[:title] = self.name
	h[:checked] = false
	h
  end
end