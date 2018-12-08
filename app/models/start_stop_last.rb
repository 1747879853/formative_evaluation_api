class StartStopLast < ApplicationRecord
  def as_json(options = {})
    h = {}
    h[:well_id] = self.well_id
    h[:record_time] = self.record_time
    h[:work_type_id] = self.work_type_id
    h[:status] = self.get_status
    h
  end

  def get_status
    flag = 0
    if self.work_type_id != 1
      if self.work_type_id == 2
        if self.record_time.year == Time.now.year and self.record_time.month == Time.now.month and self.record_time.day == Time.now.day
          flag = 1
        else
          flag = -1
        end
      else
        flag = -1
      end
    end
    return flag
  end

end