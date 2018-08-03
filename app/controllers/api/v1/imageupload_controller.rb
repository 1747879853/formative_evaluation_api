class Api::V1::ImageuploadController < Api::V1::BaseController
	def upload
		imagefile = params[:file]
		image_relative_path = imagefile.original_filename
		image_path = File.expand_path(File.dirname(__FILE__)+'/../../../..')+'/public/_attachment/'+image_relative_path
		data = File.read(params[:file].path)
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
	end
end