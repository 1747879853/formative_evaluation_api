class WorkTeamTaskDetail < ApplicationRecord

	belongs_to :work_team_task

	belongs_to :user
  

  def as_json(option = {})
  	h = super(option)
  	h[:record_time] = self.record_time.strftime("%Y-%m-%d %H:%M:%S").to_s
  	h[:user_name] = User.find_by(id: self.user_id).username
  	h
  end
end
