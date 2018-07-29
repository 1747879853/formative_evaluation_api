class Api::V1::ImageuploadController < Api::V1::BaseController
	def upload
		# puts current_user
		# if not Auth.check('approval/approval_admin_list', current_user)
	 #    	unauthorized 
	 #    	return
	 #    end
		# unauthorized and return unless Auth.check('work_order/post_image', current_user)
		# puts "----------"
		# puts params[:file]
		# file = Imgfile.new(params[:file])
		# if file.save
		# 	puts "--------------------------"
		# 	# puts "#{RAILS_ROOT}"
		# 	# puts file
		# 	# renger json: {

		# 	# }
		# else
		# 	puts "+++++++++++++++++++++++++++"

		# end
		image_relative_path = "/assets/images/#{params[:type]}/#{Time.now.to_i}.png"
		image_path = File.expend_path(File.dirname(_FILE_)+'/../..')+"public"+image_relative_path
		data = File.read(params[:file].path)
		img = File.new(image_path,"wb+")
		if img
			img.syswrite(data)
		end
		img.close
		render json:{url: image_relative_path}
	end
end