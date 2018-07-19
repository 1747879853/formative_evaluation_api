class WorkTeamTask < ApplicationRecord

	belongs_to :work_team
	belongs_to :material
	belongs_to :user
  
end
