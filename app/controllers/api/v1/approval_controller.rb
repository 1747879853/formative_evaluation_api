class Api::V1::ApprovalController < Api::V1::BaseController
	# before_action :authorize
  
	def approval_list
	    # unauthorized and return unless 
	    if not Auth.check('approval/approval_list', current_user)
	    	unauthorized 
	    	return
	    end
	    render json: Approval.where(status: 1)
	end

	def approval_field_list
	    # unauthorized and return unless 
	    if not Auth.check('approval/approval_list', current_user)
	    	unauthorized 
	    	return
	    end
	    app = Approval.find_by(id: params[:approval_id])
	    pro = Procedure.where(approval_id: params[:approval_id]).where(status: 1).first
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

	def approval_create
	  	if not Auth.check('approval/approval_create', current_user)
	    	unauthorized 
	    	return
	    end


	  	#always create a new approval whether click create a new or modify old approval
	  	t = Time.now
	  	ts = t.strftime('%Y%m%d%H%M%S')

	  	begin
			apr = Approval.new	
			apr.name = params[:approval_name]
			apr.en_name_main = 'Approval'+ts
			apr.en_name_detail = 'ApprovalDetail'+ts
			apr.comment = params[:approval_comment]
			apr.created_time = t
			apr.stoped_time = nil
			apr.status = 1
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

			app_field_str = ApprovalField.generateStr(app_field_name,app_field_ctl)
			console_cmd1 ="rails generate model " + apr.en_name_main + " " + app_field_str +'--no-assets --no-test-framework'

			system(console_cmd1)

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
				system(console_cmd2)
			end
			# open model file and add some has_many etc

			system("rails db:migrate")

		  	#create success,then stop the old approval
		  	#if id==-1表示创建新审批，否则是修改旧的审批
		  	#new approval's create time === old approval's stop time
		  	if params[:approval_id]!="-1"  
		  		app = Approval.find_by(id: params[:approval_id])
		  		app.status = 0 if app
		  		app.stoped_time =t if app
		  	end

			render json:{msg: '保存成功',code: 1}
	  	rescue Exception => e
	  		render json:{msg: '保存失败',code: 0}
	  	end
	  	


	    # approval_field_data:主表表单字段信息
	    # approval_detail_field_data: 详表字段信息，如果没有则为[]
	end

	def approval_save
		if not Auth.check('approval/approval_list', current_user)
	    	unauthorized 
	    	return
	    end
	    app = Approval.find_by(id: params[:approval_id])
	    model_main = app.en_name_main.classify.constantize
	    # model_detail = app.en_name_detail.classify.constantize
        
        p params[:detailhash]            
	    mm = model_main.new(params[:mainhash])
	    # mm.save!

	    render json:{msg: '保存成功',code: 1}

	end

# <Option value="单行输入框">单行输入框</Option>
# <Option value="多行输入框">多行输入框</Option>
# <Option value="单选框">单选框</Option>
# <Option value="多选框">多选框</Option>
# <Option value="日期">日期</Option>

  
end
