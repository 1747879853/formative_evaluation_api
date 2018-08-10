class Api::V1::ApprovalController < Api::V1::BaseController
	# before_action :authorize
  
  	def approval_admin_list
	    # unauthorized and return unless 
	    if not Auth.check('approval/approval_admin_list', current_user)
	    	unauthorized 
	    	return
	    end

	    render json:{
			code: 1,
			msg: "success",
			data: ApprovalAdmin.all.order('status DESC,created_time')
		}
	end
	def approval_list   #not used
	    # unauthorized and return unless 
	    if not Auth.check('approval/approval_list', current_user)
	    	unauthorized 
	    	return
	    end

	    render json:{
			code: 1,
			msg: "success",
			data: Approval.all.order(status: :desc),
		}
	end
	def approval_list_inuse
	    # unauthorized and return unless 
	    if not Auth.check('approval/approval_list_inuse', current_user)
	    	unauthorized 
	    	return
	    end
	    # the rows in json should in approval_to_me,here is by the way
	    render json:{
			code: 1,
			msg: "success",
			data: ApprovalAdmin.all.where(status: 1),
			rows: ApprovalCurrentNode.where(user_id: current_user.id).where(status: 0).length			
		}
	end

	def approval_field_list
	    # unauthorized and return unless 
	    if not Auth.check('approval/approval_field_list', current_user)
	    	unauthorized 
	    	return
	    end

	    app_admin = ApprovalAdmin.find_by(id: params[:approval_admin_id])
	    app = app_admin.approvals.where(status: 1).first
	    
	    pro = Procedure.where(approval_id: app.id).where(status: 1).first
	    if pro 
	    #suggest owner_type in procedure_nodes is 'Role'
	    #suggest owner_id in procedure_nodes is one of role's id
	    	pro_nodes = pro.procedure_nodes.order(:sequence)
	    	node_ids = pro_nodes.map(&:id)
	    	role_ids = pro_nodes.map(&:owner_id)
	    	submit_users = AuthGroup.find_by(id: role_ids.first) ? AuthGroup.find_by(id: role_ids.first).users : []
	    
		    #??????????????????
		    #need  add  node_ids steps like dingding
		    render json: {
		    	'msg': 'success',
		    	'code': 1,
		    	'submit_users': submit_users,
		    	'approval_data': app,
		    	'approval_field_data': app.approval_fields.order(:sequence) || [],
		    	'approval_detail_field_data': app.approval_detail_fields.order(:sequence) || []
		    }
		else  #如果没有设置该审批的流程，返回错误
			render json:{ msg: '该审批的流程未设置！',code: 0}

		end
	end

	def approval_field_edit
	    # unauthorized and return unless 
	    if not Auth.check('approval/approval_field_edit', current_user)
	    	unauthorized 
	    	return
	    end

	    app_admin = ApprovalAdmin.find_by(id: params[:approval_admin_id])
	    app = app_admin.approvals.where(status: 1).first
	    
	    render json: {
	    	'msg': 'success',
	    	'code': 1,
	    	'approval_data': app,
	    	'approval_field_data': app.approval_fields.order(:sequence) || [],
	    	'approval_detail_field_data': app.approval_detail_fields.order(:sequence) || []
	    }
		
	end
	# 创建新审批 或 编辑表单 的保存
	def approval_create
	  	if not Auth.check('approval/approval_create', current_user)
	    	unauthorized 
	    	return
	    end
	  	#always create a new approval whether click create a new or modify old approval
	  	t = Time.now
	  	ts = t.strftime('%Y%m%d%H%M%S')

	  	begin
	  		cmd_all_success = false
	  		cmd1_success = false
	  		cmd2_success = false
	  		cmd3_success = false

	  		para_admin_id = params[:approval_admin_id] 
  			para_name = params[:approval_admin_name]
  			para_comment = params[:approval_admin_comment]

	  		if para_admin_id == 0  #表示创建新审批
	  			para_name = params[:approval_admin_name]
	  			para_comment = params[:approval_admin_comment]

		  		all_name = ApprovalAdmin.all.map(&:name)
		  		if all_name.index(para_name) && all_name.index(para_name) >= 0
		  			render json:{ msg: '审批名称与已有审批重名!',code: 1}
		  			return
		  		end		  	

		  		apr_admin = ApprovalAdmin.new
		  		apr_admin.name = para_name
				apr_admin.comment = para_comment
				apr_admin.created_time = t
				apr_admin.status = 1
				apr_admin.save!


				apr = Approval.new	
				apr.name = para_name
				apr.en_name_main = 'Approval'+ts
				apr.en_name_detail = 'ApprovalDetail'+ts
				apr.comment = para_comment
				apr.created_time = t
				apr.stoped_time = nil
				apr.status = 1
				apr.approval_admin_id = apr_admin.id
				apr.save!

				# apr.id
				app_field_name = []
				app_field_ctl = []
				app_field_str = ""
				params[:approval_field_data].each_with_index  do |value,index|
					af = ApprovalField.new
					af.approval_id = apr.id
					af.name = value[:name] 
					af.en_name = 'field'+ value[:sequence].to_s
					af.control = value[:control]
					af.comment = value[:comment]
					af.info = value[:info]
					af.sequence = value[:sequence]
					af.selectoptions = value[:selectoptions]
					af.dateformat = value[:dateformat]
					af.save!

					app_field_name << af.en_name
					app_field_ctl << value[:control]			
				end

				app_field_str = ApprovalField.generateStr(app_field_name,app_field_ctl) + ApprovalField.solid_field_str()
				console_cmd1 ="rails generate model " + apr.en_name_main + " " + app_field_str +'--no-assets --no-test-framework'

				# system(console_cmd1)
				console_cmd2 = nil
				if params[:approval_detail_field_data].length >0
					app_field_name_d = []
					app_field_ctl_d = []
					app_field_str_d = ""
					params[:approval_detail_field_data].each_with_index  do |value,index|
						af = ApprovalDetailField.new
						af.approval_id = apr.id
						af.name = value[:name] 
						af.en_name = 'field'+ value[:sequence].to_s
						af.control = value[:control]
						af.comment = value[:comment]
						af.info = value[:info]
						af.sequence = value[:sequence]
						af.selectoptions = value[:selectoptions]
						af.dateformat = value[:dateformat]
						af.save!

						app_field_name_d << af.en_name
						app_field_ctl_d << af.control
					end
					app_field_str_d = ApprovalField.generateStr(app_field_name_d,app_field_ctl_d,apr.en_name_main)
					console_cmd2 ="rails generate model " + apr.en_name_detail + " " + app_field_str_d + '--no-assets --no-test-framework'
					# system(console_cmd2)
				else
					apr.en_name_detail = nil  #if there's no detail table,let en_name_detail=nil
					apr.save!
				end

				cmd1_ret = system(console_cmd1)
				# p("cmd1_ret:",cmd1_ret)
				if cmd1_ret
					cmd1_success = true
				else
					cmd1_success = false
				end

				if cmd1_success && console_cmd2 
					if system(console_cmd2)
						cmd2_success = true
					else
						cmd2_success = false
					end
				end
				if console_cmd2
					if cmd1_success &&  cmd2_success
						if system("rails db:migrate")
							cmd3_success = true
						else
							cmd3_success = false
						end
					end
				else
					if cmd1_success 
						if system("rails db:migrate")
							cmd3_success = true
						else
							cmd3_success = false
						end
					end
				end
				# open model file and add some has_many etc,we do not do this at here,so there is no has_many and belongs_to.
				if cmd3_success #means all command success
					#move model files from app/models/generated models to lib/approvalmodel/
					system("mv app/models/" + apr.en_name_main.underscore + ".rb" + " " + "lib/approvalmodel")
					if console_cmd2
						system("mv app/models/" + apr.en_name_detail.underscore + ".rb" + " " + "lib/approvalmodel")
					end
					cmd_all_success = true

				elsif cmd2_success #means command3 failed,so delete command1 and command2 generated files and delete all newed records
					system("rm -f app/models/" + apr.en_name_main.underscore + ".rb")
					system("rm -f app/db/migrate/*_create_" + apr.en_name_main.underscore  + "s.rb")
					if console_cmd2
						system("rm app/models/" + apr.en_name_detail.underscore + ".r-f b")
						system("rm -f app/db/migrate/*_create_" + apr.en_name_detail.underscore + "s.rb")
					end
					#delete all newed records
					#here need to complete in the future???????????


				elsif cmd1_success #means command2 and command3 failed,so delete command1 generated files
					system("rm -f app/models/" + apr.en_name_main.underscore + ".rb")
					system("rm -f app/db/migrate/*_create_" + apr.en_name_main.underscore + "s.rb")
					#delete all newed records
					#here need to complete in the future??????????
				end

						
			else  #修改旧的审批
				apr_admin = ApprovalAdmin.find_by(id: para_admin_id)
		  		apr_admin.name = para_name
				apr_admin.comment = para_comment
				apr_admin.save!

				#stop the old approval
				app = apr_admin.approvals.where(status: 1).first
				app.status = 0
				app.stoped_time = t
				app.save!



				#create the new approval
				apr = Approval.new	
				apr.name = para_name
				apr.en_name_main = 'Approval'+ts
				apr.en_name_detail = 'ApprovalDetail'+ts
				apr.comment = para_comment
				apr.created_time = t
				apr.stoped_time = nil
				apr.status = 1
				apr.approval_admin_id = apr_admin.id
				apr.save!

				#get the old approval's current used procedure
				used_proc = Procedure.where(status: 1).where(approval_id: app.id).first
				#the next line same as the before line?????
				# used_proc = app.procedures.where(status: 1).first

				if used_proc #if procedure has settled
					copied_proc = Procedure.create(used_proc.attributes.merge({created_time: t,approval_id: apr.id, id:nil}))
					used_proc.procedure_nodes.each do |pn|
						ProcedureNode.create(pn.attributes.merge({procedure_id: copied_proc.id, id:nil}))
					end
					used_proc.status = 0
					used_proc.stoped_time = t					
					used_proc.save!
				end
				# apr.id
				app_field_name = []
				app_field_ctl = []
				app_field_str = ""
				params[:approval_field_data].each_with_index  do |value,index|
					af = ApprovalField.new
					af.approval_id = apr.id
					af.name = value[:name] 
					af.en_name = 'field'+ value[:sequence].to_s
					af.control = value[:control]
					af.comment = value[:comment]
					af.info = value[:info]
					af.sequence = value[:sequence]
					af.selectoptions = value[:selectoptions]
					af.dateformat = value[:dateformat]
					af.save!

					app_field_name << af.en_name
					app_field_ctl << value[:control]			
				end

				app_field_str = ApprovalField.generateStr(app_field_name,app_field_ctl) + ApprovalField.solid_field_str()
				console_cmd1 ="rails generate model " + apr.en_name_main + " " + app_field_str +'--no-assets --no-test-framework'

				# system(console_cmd1)

				if params[:approval_detail_field_data].length >0
					app_field_name_d = []
					app_field_ctl_d = []
					app_field_str_d = ""
					params[:approval_detail_field_data].each_with_index  do |value,index|
						af = ApprovalDetailField.new
						af.approval_id = apr.id
						af.name = value[:name] 
						af.en_name = 'field'+ value[:sequence].to_s
						af.control = value[:control]
						af.comment = value[:comment]
						af.info = value[:info]
						af.sequence = value[:sequence]
						af.selectoptions = value[:selectoptions]
						af.dateformat = value[:dateformat]
						af.save!

						app_field_name_d << af.en_name
						app_field_ctl_d << af.control
					end
					app_field_str_d = ApprovalField.generateStr(app_field_name_d,app_field_ctl_d,apr.en_name_main)
					console_cmd2 ="rails generate model " + apr.en_name_detail + " " + app_field_str_d + '--no-assets --no-test-framework'
					# system(console_cmd2)
				else
					apr.en_name_detail = nil  #if there's no detail table,let en_name_detail=nil
					apr.save!
				end

				cmd1_ret = system(console_cmd1)
				# p("cmd1_ret:",cmd1_ret)
				if cmd1_ret
					cmd1_success = true
				else
					cmd1_success = false
				end

				if cmd1_success && console_cmd2 
					if system(console_cmd2)
						cmd2_success = true
					else
						cmd2_success = false
					end
				end

				if console_cmd2
					if cmd1_success &&  cmd2_success
						if system("rails db:migrate")
							cmd3_success = true
						else
							cmd3_success = false
						end
					end
				else
					if cmd1_success 
						if system("rails db:migrate")
							cmd3_success = true
						else
							cmd3_success = false
						end
					end
				end
				
				

				# open model file and add some has_many etc,we do not do this at here,so there is no has_many and belongs_to.
				if cmd3_success #means all command success
					#move model files from app/models/generated models to lib/approvalmodel/
					system("mv app/models/" + apr.en_name_main.underscore + ".rb" + " " + "lib/approvalmodel")
					if console_cmd2
						system("mv app/models/" + apr.en_name_detail.underscore + ".rb" + " " + "lib/approvalmodel")
					end
					cmd_all_success = true

				elsif cmd2_success #means command3 failed,so delete command1 and command2 generated files and delete all newed records and restore all the modified data of ApprovalAdmin etc.
					system("rm -f app/models/" + apr.en_name_main.underscore + ".rb")
					system("rm -f app/db/migrate/*_create_" + apr.en_name_main.underscore + "s.rb")
					if console_cmd2
						system("rm app/models/" + apr.en_name_detail.underscore + ".r-f b")
						system("rm -f app/db/migrate/*_create_" + apr.en_name_detail.underscore + "s.rb")
					end
					# delete all newed records and restore all the modified data of ApprovalAdmin etc.
					#here need to complete in the future???????????


				elsif cmd1_success #means command2 and command3 failed,so delete command1 generated files
					system("rm -f app/models/" + apr.en_name_main.underscore + ".rb")
					system("rm -f app/db/migrate/*_create_" + apr.en_name_main.underscore + "s.rb")
					#delete all newed records and restore all the modified data of ApprovalAdmin etc.
					#here need to complete in the future???????????
				end


			end

			if cmd_all_success
				render json:{msg: '保存成功',code: 1}
			else
				render json:{msg: '保存失败',code: 0}
			end
	  	rescue Exception => e
	  		render json:{msg: '保存失败',code: 0}
	  	end
	  	


	    # approval_field_data:主表表单字段信息
	    # approval_detail_field_data: 详表字段信息，如果没有则为[]
	end

	def approval_save
		if not Auth.check('approval/approval_save', current_user)
	    	unauthorized 
	    	return
	    end
	 #parameters like this:  
     # "approvalid":10,
     # "mainhash":{"field0":"111","field1":"222","field2":"选项1","field3":"选项2","field4":"2018-07-20T16:00:00.000Z"},
     # "detailhasharr":[{"field0":"333","field1":"选项1"},{"field0":"444","field1":"选项2"}],
     # "submit_user_id":1
     
	    t = Time.now
	  	ts = t.strftime('%Y%m%d%H%M%S%L')  #%L -Millisecond of the second (000..999)

	    params.permit(:approvaladminid)
	    params.permit(:submit_user_id)
	    
    	params.require(:mainhash).permit!
		
		d_hash_arr = []
		if params[:detailhasharr].length > 0
			detail_arr_permit
			d_hash_arr = params[:detailhasharr]
		end


		appadmin_id = params[:approvaladminid]
		m_hash = params[:mainhash]
		sui = params[:submit_user_id]

		app_admin = ApprovalAdmin.find_by(id: appadmin_id)
	    app = app_admin.approvals.where(status: 1).first
	    begin	    	
		    
		    model_main = app.en_name_main.classify.safe_constantize
	        
	        # the next fields are solid added at server,not filled by client.
	        m_hash["approval_id"] = app.id
	        m_hash["approval_name"] = app.name
	        m_hash["user_id"] = current_user.id   # who submited the approval
	        m_hash["no"] =  ts
	        m_hash["submit_time"] = t
	        m_hash["finish_time"] = nil
			pro = app.procedures.where(status: 1).first
			m_hash["procedure_id"] = pro.id
			# p_nodes = pro.procedure_nodes.order(:sequence)
			# m_hash["node_ids"] = p_nodes.map(&:id).join(",")
			# m_hash["role_ids"] = p_nodes.map(&:owner_id).join(",")
			# m_hash["node_id_now"] = p_nodes.first.id
			# m_hash["submit_to_user_id"] = sui
			m_hash.delete("xxx")  #fuck rails parameters permit!
		    mm = model_main.create(m_hash)

		    if d_hash_arr.length>0
		    	main_key_id = app.en_name_main.downcase + '_id'
				model_detail = app.en_name_detail.classify.safe_constantize

				d_hash_arr.each do |hh|
					hh[main_key_id] = mm.id
					model_detail.create(hh)
				end
			end
			p_nodes = pro.procedure_nodes.order(:sequence)
			cur_node = ApprovalCurrentNode.new
			cur_node.node_ids = p_nodes.map(&:id).join(",")
			cur_node.procedure_node_id = p_nodes.first.id
			cur_node.user_id = sui
			cur_node.status = 0
			cur_node.owner = mm
			cur_node.submit_user_id = mm.user_id
			cur_node.save!


			render json:{msg: '保存成功',code: 1}
		rescue Exception => e
			render json:{msg: '保存失败',code: 0}	    	
	    end
	end

# <Option value="单行输入框">单行输入框</Option>
# <Option value="多行输入框">多行输入框</Option>
# <Option value="单选框">单选框</Option>
# <Option value="多选框">多选框</Option>
# <Option value="日期">日期</Option>

	def approval_to_me
		if not Auth.check('approval/approval_to_me', current_user)
	    	unauthorized 
	    	return
	    end

		acn = ApprovalCurrentNode.where(user_id: current_user.id).where(status: 0)
		ret_data = []
		acn.each do |val|
			hh ={}
			mt = val.owner
			hh[:app_cur_id] = val.id
			hh[:title] = (User.find(mt.user_id).username + '的' + mt.approval_name) 
			hh[:digest] = '待定'
			hh[:submit_time] = mt.submit_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
			hh[:finish_time] = mt.finish_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
			# hh[:status] = User.find(val.user_id).username + '审批中...'
			hh[:status] = current_user.username + '审批中...'			
			ret_data << hh

		end
		render json:{
			code: 1,
			msg: "success",
			data: ret_data,
			rows: ret_data.length
		}
	end
	def approval_info
		if not Auth.check('approval/approval_info', current_user)
	    	unauthorized 
	    	return
	    end
		acn = ApprovalCurrentNode.find_by(id: params[:app_cur_id])
		mt = acn.owner  #auto creted main table
		app = Approval.find(mt.approval_id) #main table has approval_id

		to_me_flag = false
		# 审批未完成并且审批人==current_user,才给to_me_flag = true
		if acn.status == 0 && acn.user_id == current_user.id
			to_me_flag = true
		end

		node_arr = acn.node_ids.split(",").map(&:to_i)

		submit_to_users = []  #只有最后一个节点的submit_to_users为空
		if acn.procedure_node_id != node_arr.last  #the last node
			proc_node_id = node_arr[node_arr.index(acn.procedure_node_id) + 1]
			submit_to_users = ProcedureNode.find(proc_node_id).owner.users
		end
		

		ret_data = {}
		ret_data[:cur_node] = acn
		ret_data[:main_record] = mt
		ret_data[:detail_records] = []
		if app.en_name_detail
			model_detail = app.en_name_detail.classify.constantize
			str = app.en_name_main.downcase + '_id=' + (mt.id).to_s
			ret_data[:detail_records] = model_detail.where("#{str}")
		end	

		ret_data[:approval_record] = app
		ret_data[:proc_node_details] = ApprovalDetail.where(owner: mt).order(:action_time)
		ret_data[:proc_nodes] = Procedure.find(mt.procedure_id).procedure_nodes.order(:sequence)


		app_no = {}
		app_no["审批编号"] = mt.no

		main_table_fields = {}
		app.approval_fields.order(:sequence).each do |value|
			main_table_fields[value.name] = mt[value.en_name]
		end

		detail_table_fields_arr = []
		if app.en_name_detail
			ret_data[:detail_records].each_with_index do |value,index|
				t = {}
				
				app.approval_detail_fields.each do |ff|
					t[ff.name] = value[ff.en_name]
				end
				detail_table_fields_arr << t
			end
		end



		n_details = {}
		ret_data[:proc_node_details].each do |value|
			n_details[value.procedure_node_id] = value
		end

		proc_arr = []
		#the first node is the submit form node
		first_node = {}
		first_node[:whowho] = User.find(mt.user_id).username
		first_node[:act_str] = "发起申请"
		first_node[:act_time] =  mt.submit_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
		proc_arr << first_node

		flag = 0
		ret_data[:proc_nodes].each do |nn|  #all procedure nodes
			tt={}
			tt[:title] = nn.name
			if n_details[nn.id] # done node
				tt[:whowho] = User.find(n_details[nn.id].user_id).username
				tt[:act_str] = n_details[nn.id].action_str
				tt[:act_time] = n_details[nn.id].action_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
				tt[:comment] = n_details[nn.id].comment
			elsif flag == 0 && acn.status != 2 #first undone node
				tt[:whowho] = User.find(acn.user_id).username
				tt[:act_str] = '审批中'
				flag = 1		
			elsif flag == 1  #other undone node
				tt[:whowho] = ''
				tt[:act_str] = ''
			end
			proc_arr << tt
		end



		render json:{
			code: 1,
			msg: "success",
			appno: app_no,
			main_fields: main_table_fields,
			detail_fields: detail_table_fields_arr,
			procedure_nodes: proc_arr,
			detail_title: (app.name + '明细'),
			to_me_flag: to_me_flag,
			submit_to_users: submit_to_users
		}
	end

	def approval_to_me_done
		if not Auth.check('approval/approval_to_me_done', current_user)
	    	unauthorized 
	    	return
	    end

		ad = ApprovalDetail.where(user_id: current_user.id)
		ret_data = []
		ad.each do |val|
			hh ={}
			mt = val.owner
			acn = ApprovalCurrentNode.where(owner: mt).first

			hh[:app_cur_id] = acn.id
			hh[:title] = (User.find(mt.user_id).username + '的' + mt.approval_name) 
			hh[:digest] = '待定'
			hh[:submit_time] = mt.submit_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
			hh[:finish_time] = mt.finish_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
			if acn.status == 1
				hh[:status] = '审批通过'
			elsif acn.status == 2
				hh[:status] = '审批拒绝'
			elsif acn.status == 0
				hh[:status] = User.find(acn.user_id).username + '审批中...'
			end	
		
			ret_data << hh

		end

		render json:{
			code: 1,
			msg: "success",
			data: ret_data,
            rows: ret_data.length
		}
	end
	def approval_from_me
		if not Auth.check('approval/approval_from_me', current_user)
	    	unauthorized 
	    	return
	    end

		acn = ApprovalCurrentNode.where(submit_user_id: current_user.id)
		ret_data = []
		acn.each do |val|
			hh ={}
			mt = val.owner
			hh[:app_cur_id] = val.id
			hh[:title] = (User.find(mt.user_id).username + '的' + mt.approval_name) 
			hh[:digest] = '待定'
			hh[:submit_time] = mt.submit_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
			hh[:finish_time] = mt.finish_time.try(:strftime,'%Y-%m-%d %H:%M:%S')
			if val.status == 1
				hh[:status] = '审批通过'
			elsif val.status == 2
				hh[:status] = '审批拒绝'
			elsif val.status == 0
				hh[:status] = User.find(val.user_id).username + '审批中...'
			end	
		
			ret_data << hh

		end

		render json:{
			code: 1,
			msg: "success",
			data: ret_data,
            rows: ret_data.length
      }
	end

	def approval_pass
		if not Auth.check('approval/approval_pass', current_user)
	    	unauthorized 
	    	return
	    end

		acn = ApprovalCurrentNode.find_by(id: params[:app_cur_id])
		begin
			t_now = Time.now
			ad = ApprovalDetail.new
			ad.procedure_node_id = acn.procedure_node_id
			ad.action_str = "同意"
			ad.comment = params[:comment]
			ad.action_time = t_now
			ad.user_id = acn.user_id 
			ad.owner_id = acn.owner_id
			ad.owner_type = acn.owner_type
			ad.save

			node_arr = acn.node_ids.split(",").map(&:to_i)

			if acn.procedure_node_id == node_arr.last  #the last node
				# acn.user_id = nil
				# acn.procedure_node_id = nil
				acn.status = 1

				# 该审批已经完成，所以填入完成时间
				mt = acn.owner
				mt.finish_time = t_now
				mt.save
			else
				acn.procedure_node_id = node_arr[node_arr.index(acn.procedure_node_id) + 1]
				acn.user_id = params[:submit_to_user_id]
				acn.status = 0
			end
			acn.save			

			render json:{msg: '保存成功',code: 1}
		rescue Exception => e
			render json:{msg: '保存失败',code: 0}
		end


	end
	def approval_reject
		if not Auth.check('approval/approval_reject', current_user)
	    	unauthorized 
	    	return
	    end

		acn = ApprovalCurrentNode.find_by(id: params[:app_cur_id])
		begin
			t_now = Time.now

			mt = acn.owner
			mt.finish_time = t_now
			mt.save

			ad = ApprovalDetail.new
			ad.procedure_node_id = acn.procedure_node_id
			ad.action_str = "拒绝"
			ad.comment = params[:comment]
			ad.action_time = t_now
			ad.user_id = acn.user_id
			ad.owner = acn.owner
			ad.save!

			#because the user_id and procedure_node_id created by reference,so can't set nil or 0, so not change it.
			# acn.user_id = nil		
			# acn.procedure_node_id = nil
			acn.status = 2
			acn.save! 

			render json:{msg: '保存成功',code: 1}
		rescue Exception => e
			render json:{msg: '保存失败',code: 0}
		end
	end
	def approval_admin_stop
		begin
			app = ApprovalAdmin.find_by(id: params[:approval_admin_id])
			app.status = 0
			app.save!
			render json:{msg: '保存成功',code: 1}
		rescue Exception => e
			render json:{msg: '保存失败',code: 0}
		end

	end
	def approval_admin_start
		begin
			app = ApprovalAdmin.find_by(id: params[:approval_admin_id])
			app.status = 1
			app.save!
			render json:{msg: '保存成功',code: 1}
		rescue Exception => e
			render json:{msg: '保存失败',code: 0}
		end
	end

private
	def detail_arr_permit
		params.require(:detailhasharr).map do |pp|
		  pp.permit!
		end
	end
	
  
end
