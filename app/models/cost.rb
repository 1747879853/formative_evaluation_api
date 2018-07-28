class Cost < ApplicationRecord

  acts_as_tree

  validates_presence_of     :title

  def as_json(options = {})
		h = {}	
		h[:id] = self.id
		h[:title] = self.title
		h[:expand] = true
		h[:children] = self.children if self.children
		h
	end
end