class DailyOutputLast < ApplicationRecord
  def as_json(option = {})
    h  = {}
    h[:well_id] = self.well_id
    h[:daily_output_avg] = self.average_weight
    h
  end

end