class WorkTeamTask < ApplicationRecord

	belongs_to :work_team
	belongs_to :material
	belongs_to :user
	has_many   :boms_apprpvals
	has_many 	 :work_logs,as: :owner


	def as_json(opts = {})
		h = super(opts)
	  h1 = {}
    self.process ? self.process.split(',').each {|e| h1[e] = WorkTeam.find(e).name} : ""
    h[:flow] = h1.values.join(",")
    h[:current_flow]  =h1[self.work_team_id.to_s]
    h
	end
  
end
