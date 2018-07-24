class WorkLog < ApplicationRecord
 	belongs_to :owner, polymorphic: true

 	def as_json(option={})
 		h = super(option)
 		h[:record_time] = self.record_time.strftime('%Y-%m-%d %H:%M:%S').to_s
 		h
 	end
end
