class WellWgStd < ActiveRecord::Base
  self.table_name='std_indicator_diagram_lasts'
  self.primary_keys = :well_id

  belongs_to :well_base, foreign_key: "well_id"

  def ids
  	self.well_id
  end
  
  include Spots
end

# class Legacy::WellWgStd < Legacy::Base
#   self.table_name = 'WellWGStd'
#   self.primary_keys = :well_ID

#   belongs_to :well_base

#   # self.per_page = 1

#   def ids
#   	self.well_ID
#   end
  
#   include Spots
# end