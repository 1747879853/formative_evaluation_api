class ApprovalDetail < ApplicationRecord
    belongs_to :procedure_node
	belongs_to :owner, polymorphic: true
	belongs_to :user
end
