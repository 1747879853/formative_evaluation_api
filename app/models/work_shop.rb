class WorkShop < ApplicationRecord
  has_many :work_teams
  has_many :users
end
