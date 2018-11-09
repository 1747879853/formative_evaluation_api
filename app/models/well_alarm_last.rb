class WellAlarmLast < ActiveRecord::Base
	self.table_name='alarm_lasts'
	# self.primary_keys = :well_id
	
	belongs_to :well_base
end