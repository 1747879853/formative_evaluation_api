class WellDataRelation < ApplicationRecord
  def as_json(option={})
    h = {}
    h[:well_id] = self.well_id
    h[:sensor_type_id] = self.sensor_type_id
  end
end