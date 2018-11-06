class WellWgStdM < ActiveRecord::Base
	self.table_name='std_indicator_diagrams'
  self.primary_keys = :well_id, :record_time

  belongs_to :well_base, 
    foreign_key: "well_id",
    primary_key: "well_id"

  include Spots
end

# class Legacy::WellWgStdM < Legacy::Base
#   self.table_name = 'WellWGStdM'
#   self.primary_keys = :well_ID, :well_time, :record_time

#   belongs_to :well_base, 
#     foreign_key: "Well_ID",
#     primary_key: "well_ID"



#   include Spots
# end