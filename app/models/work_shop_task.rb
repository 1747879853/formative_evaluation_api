class WorkShopTask < ApplicationRecord

	belongs_to :work_shop
	belongs_to :work_order
	belongs_to :user
	has_many   :work_logs,as: :owner
	has_many   :work_teamx_tasks
  
end
