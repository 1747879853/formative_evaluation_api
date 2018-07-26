class ApprovalAdmin < ApplicationRecord
  has_many :approvals

  	def as_json(options = {})
		h = super(options)
		h[:created_time] = self.created_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
		h
	end
end
