class WorkLog < ApplicationRecord
 	belongs_to :owner, polymorphic: true



 	def as_json(option={})
 		h = super(option)
 		h[:record_time] = self.record_time.strftime('%Y-%m-%d %H:%M:%S').to_s
 		h[:user_name] = User.find_by_id(self.user_id).username
 		h[:type] =self.owner_type=="WorkShopTask" ? '车间任务单' : '班组任务单'
 		h[:get_user_name] = User.find_by_id(self.get_user_id).username
 		h
 	end
end
