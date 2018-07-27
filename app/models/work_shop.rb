class WorkShop < ApplicationRecord
  has_many :work_teams
  has_many :work_shop_tasks
  belongs_to :user



end
