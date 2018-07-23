class AuthRule < ApplicationRecord
  has_and_belongs_to_many :auth_groups
  has_many :users, through: :auth_groups

  acts_as_tree

  scope :active, -> { where status: 1 }

  validates_presence_of     :name
  validates_presence_of     :title
  validates_uniqueness_of   :name
  validates_uniqueness_of   :title

  def as_json(options = {})
		h = {}	
		h[:id] = self.id
		h[:title] = self.title
		h[:expand] = true
		h[:checked] = false
		h[:children] = self.children if self.children
		h
	end
end
