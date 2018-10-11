class OrganizationsUser < ApplicationRecord
	belongs_to :user
	belongs_to :organization

	def as_json(option = {})
  	h = super(option)
  	h[:username] = User.find_by_id(self.user_id).username
  	h
  end
end