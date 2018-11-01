class Region < ApplicationRecord
  
  has_many :region_users
  has_many :users, through: :region_users

  acts_as_tree

  

  def as_json(options = {})
	h = {}	
	h[:id] = self.id
	h[:name] = self.name
	h[:parent_id] = self.parent_id
	h[:children] = self.children if self.children
	h
  end
end
