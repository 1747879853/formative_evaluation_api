class Material < ApplicationRecord
  belongs_to :work_order
  has_many :boms
  has_many :work_team_tasks
end
