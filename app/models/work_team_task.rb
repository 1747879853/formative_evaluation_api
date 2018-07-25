class WorkTeamTask < ApplicationRecord

	belongs_to :work_team
	belongs_to :material
	belongs_to :user
	has_many   :boms_apprpvals
	has_many 	 :work_logs,as: :owner
  
end
