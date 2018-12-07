class AlarmType < ActiveRecord::Base
  def self.get_alarm_type_id alarm_type
    alarm_type.split.inject(0){|sum, typ | sum += self.find_by(name: typ).try(:id).to_i }
  end

  def self.get_alarm_type_string_by_id alarm_type_id
        ati=alarm_type_id.to_i
  	  str=""
  	  self.all.each do |at|
  	  	if( at.id & ati != 0 )
  	  		str+=at.name+","
  	  	end
  	  end
  	  str=str.chop
  end
end
