class Api::V1::UploadController < Api::V1::BaseController
  
	def upload_student_template
		upload_file = params[:file]
		file_name = upload_file.original_filename
		file_path = File.expand_path(File.dirname(__FILE__) + '/../../../..') + '/public/_attachment/' + file_name
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
			status: true,
			file_name: file_name,
			# url: file_path	
		}
	end

	def delete_student_template
		f_name = params[:params][:file_name]
		
		f_path = File.expand_path(File.dirname(__FILE__)+'/../../../..')+'/public/_attachment/'+f_name
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

	def get_student_template_url
		et = ExcelTemplate.find_by(file_used_by: 'student_info')
		if(et)
			render json:{
				code: '0000',
				# stu_template_url: 'http://127.0.0.1:3000/_attachment/' + et.file_name
				# stu_template_url: 'http://47.100.174.14:9999/_attachment/' + et.file_name
				stu_template_url: '/_attachment/' + et.file_name
			}
		else
			render json:{
				code: '1111',
				stu_template_url: '#'
			}
		end
	end


	def upload_course_outline
		upload_file = params[:file]
		# p upload_file.original_filename
		# p params[:id]
		file_name = upload_file.original_filename
		file_path = File.expand_path(File.dirname(__FILE__) + '/../../../..') + '/public/course_outline/' + file_name
		
		et = Course.find_by(id: params[:id])

		if File.exist?(file_path) # server exist a same name file 
			if et.outline_url && et.outline_url == file_path   # the same name file is the current course's outline_name
				File.delete(et.outline_url)  #delete old
				data = File.read(upload_file.path)  #add new
				new_file = File.new(file_path, "wb+")
				if new_file
					new_file.syswrite(data)
				end
				new_file.close			

				et.outline_name = file_name
				et.outline_url = file_path
				et.save!

				render json:{				
					file_name: file_name,
					status: true
					# url: file_path	
				}
			else  #the same name file is not the current course's outline_name, return : has same name file!!!
				render json:{				
					file_name: file_name,
					status: false
				}
			end
		else
			#delete the current course's old file if exist
			if et.outline_url && File.exist?(et.outline_url)
				File.delete(et.outline_url)
			end

			data = File.read(upload_file.path)
			new_file = File.new(file_path, "wb+")
			if new_file
				new_file.syswrite(data)
			end
			new_file.close			

			et.outline_name = file_name
			et.outline_url = file_path
			et.save!

			render json:{				
				file_name: file_name,
				status: true
				# url: file_path	
			}
		end
	end
	
end
