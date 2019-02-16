class Evaluation < ApplicationRecord
  has_and_belongs_to_many :courses

  acts_as_tree

  def as_json(options = {})
	h = super(options)
	h[:title] = self.name
	h[:checked] = false
	h[:expand] = true
	h[:children] = self.children.where(status:1) if self.children.where(status:1)
	h
  end
end