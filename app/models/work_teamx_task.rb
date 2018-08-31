class WorkTeamxTask < ApplicationRecord
  belongs_to :work_shop_task
  has_many :work_teamx_task_details
end
