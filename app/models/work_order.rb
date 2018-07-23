class WorkOrder < ApplicationRecord
  belongs_to :order
  has_many :materials
  has_many :boms, through: :materials
  has_many :work_shop_tasks
  has_many :work_logs,as: :owner
end
