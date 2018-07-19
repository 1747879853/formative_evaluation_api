class WorkShopTask < ApplicationRecord

	belongs_to :work_shop
	belongs_to :work_order
	belongs_to :user
  
end
