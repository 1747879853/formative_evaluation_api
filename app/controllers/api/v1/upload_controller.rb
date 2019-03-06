class Api::V1::UploadController < Api::V1::BaseController
  
	def upload_student_template
		upload_file = params[:file]
		file_name = upload_file.original_filename
		file_path = File.expand_path(File.dirname(__FILE__) + '/../../../..') + '/public/' + file_name
		data = File.read(upload_file.path)
		new_file = File.new(file_path, "wb+")
		if new_file
			new_file.syswrite(data)
		end
		new_file.close
		et = ExcelTemplate.new
		et.file_used_by = 'student_info'
		et.file_name = file_name
		et.file_path = file_path
		et.upload_time = Time.now
		et.save!

		render json:{
			file_name: file_name,
			# url: file_path	
		}
	end

	def delete_student_template
		f_name = params[:params][:file_name]
		
		f_path = File.expand_path(File.dirname(__FILE__)+'/../../../..')+'/public/'+f_name
		if File.exist?(f_path)
			File.delete(f_path)
			# et = ExcelTemplate.find_by(file_used_by: 'student_info')
			et = ExcelTemplate.find_by(file_name: f_name)
			if et
				et.delete
			end
			render json:{
				status: true
			}
		else
			render json:{
				status: false
			}
		end
	end
	def get_student_template
		et = ExcelTemplate.find_by(file_used_by: 'student_info')
		if et
			render json:{
				status: true,
				file_name: et.file_name
			}
		else
			render json:{
				status: false,
				file_name: ''
			}
		end
	end
	
end
