class DailyOutputLast < ApplicationRecord
  # attribute :daily_output_avg, :integer, default: -> {
  #   # 假定没有数据的为0
  #   value = DailyOutputLast.where(well_id: self.well_id).map{|p| p.average_weight}[0].to_s
  #   if value == ""
  #     value = 0
  #   end
  #   # write_attribute :daily_output_a, value
  #   value
  # }
  def daily_output_avg
    self.daily_output.try(:averagre_weight).to_f
  end



  def as_json(option = {})
    h  = {}
    h[:well_id] = self.well_id
    h[:well_name] = self.get_well_name
    h[:daily_output_avg] = self.daily_output_avg
    h
  end
  def get_well_name
    WellBase.where(well_id: self.well_id).map{|p| p.well_name}[0]
  end

end