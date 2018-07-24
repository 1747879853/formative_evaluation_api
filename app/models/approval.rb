class Approval < ApplicationRecord
  has_many :approval_fields
  has_many :approval_detail_fields
  has_many :procedures

  	def as_json(options = {})
		h = super(options)
		h[:created_time] = self.created_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
		
		h[:stoped_time] = self.stoped_time.try(:strftime,'%Y-%m-%d %H:%M:%S')

		h
	end
end
