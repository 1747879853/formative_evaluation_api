class Organization < ApplicationRecord
  acts_as_tree

  has_many :organizations_users
  has_many :users, through: :organizations_users

  def as_json(options = {})
	h = {}	
	h[:id] = self.id
    h[:name] = self.name
    h[:parent_id] = self.parent_id
	h[:children] = self.children if self.children
	h
	end
end