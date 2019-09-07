class StuHomework < ApplicationRecord
	belongs_to :students, foreign_key: 'students_id'
 #  def as_json(options = {})
	# h = super(options)	
	# h[:title] = self.name
	# h[:checked] = false
	# h[:checked_id] = evaluations.map(&:id)
	# h
 #  end
end