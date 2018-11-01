class Region < ApplicationRecord
  
  has_many :region_users
  has_many :users, through: :region_users

  acts_as_tree

  

 #  def as_json(options = {})
	# 	h = {}	
	# 	h[:id] = self.id
	# 	h[:title] = self.title
 #    h[:name] = self.title
 #    h[:authority] = self.name
 #    h[:condition] = self.condition
 #    h[:status] = self.status == 1 ? '激活' : '停用'
	# 	h[:expand] = true
	# 	h[:checked] = false
	# 	h[:children] = self.children if self.children
	# 	h
	# end
end
