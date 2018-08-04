class RuihongCar < ApplicationRecord
	
	def as_json(options = {})
		h = super(options)
		h[:in_time] = self.in_time ? self.in_time.strftime("%Y-%m-%d %H:%M"): ""	
		h[:out_time] = self.out_time ? self.out_time.strftime("%Y-%m-%d %H:%M"): ""
		h
	end

end
