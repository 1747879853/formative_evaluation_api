class Region < ApplicationRecord
  
  has_many :region_users
  has_many :users, through: :region_users

  has_many :region_well_bases
  has_many :well_bases, through: :region_well_bases

  acts_as_tree

  

  def as_json(options = {})
	h = {}	
	h[:id] = self.id
	h[:title] = self.title
	h[:parent_id] = self.parent_id
	h[:expand] = true
	h[:children] = self.children if self.children
	h
  end
end
