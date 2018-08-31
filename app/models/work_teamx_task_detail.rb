class WorkTeamxTaskDetail < ApplicationRecord
  belongs_to :work_teamx_task
  belongs_to :bom

  def as_json(opts = {})
		h = super(opts)
	  h1 = {}
    self.process ? self.process.split(',').each {|e| h1[e] = WorkTeam.find(e).name} : ""
    h[:flow] = h1.values.join(",")
    h[:current_flow]  =h1[self.current_position.to_s]
    h
	end
end
