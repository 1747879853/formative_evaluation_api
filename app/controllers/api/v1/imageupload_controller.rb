class Api::V1::ImageuploadController < Api::V1::BaseController
	def upload

		imagefile = params[:file]
		# puts imagefile.original_filename
		# image_relative_path = Time.now.strftime("%Y-%m-%d")+"-"+imagefile.original_filename
		image_relative_path = imagefile.original_filename
		image_path = File.expand_path(File.dirname(__FILE__)+'/../../../..')+'/public/_attachment/'+image_relative_path

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

		img = File.new(image_path,"wb+")
		if img
			img.syswrite(data)
		end
		img.close

		render json:{
			file_name: image_relative_path,
			# url: image_path
		}
	end

	def delete_image
		image_name = params[:image_name]
		image_path = File.expand_path(File.dirname(__FILE__)+'/../../../..')+'/public/_attachment/'+image_name
		if File.exist?(image_path)
			File.delete(image_path)
			render json:{
				status: true
			}
		else
			render json:{
				status: false
			}
		end
=======
		render json:{url: image_relative_path}
>>>>>>> 9741bb41e5503ea92bf2cf270fd875df203337d2
	end
end