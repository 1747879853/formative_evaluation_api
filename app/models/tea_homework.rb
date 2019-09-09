class TeaHomework < ApplicationRecord

  def as_json(options = {})
	h = super(options)	
	h[:start_time] = self.start_time.strftime('%Y-%m-%d %H:%M:%S')
	h[:end_time] = self.end_time.strftime('%Y-%m-%d %H:%M:%S')
	h
  end
end