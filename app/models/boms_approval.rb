class BomsApproval < ApplicationRecord
	belongs_to :work_team_task
	has_many :boms_approval_details
	belongs_to :user

  STATUS = [:"未提交",:"审核中",:"同意",:"否决"]

  enum status: STATUS

  def as_json(options = {})
  	json = super(options)
  	json[:record_time] = self.record_time.strftime('%Y-%m-%d %H:%M:%S').to_s
  	json[:apply_name]  = User.find_by(id: self.user_id).username
  	json[:approval_owner] = User.find_by(id: self.approval_owner_id).username
  	json
  end

end
