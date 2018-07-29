class Imgfile < ApplicationRecord
	def file=(file_field)
		File.open('#{RAILS_ROOT}/../public','wb+') do |f|
			f.write(file_field.read)
		end
	end
end