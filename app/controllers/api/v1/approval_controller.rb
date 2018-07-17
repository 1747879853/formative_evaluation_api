class Api::V1::ApprovalController < Api::V1::BaseController
  # before_action :authorize
  
  def approval_list
    # unauthorized and return unless 
    if not Auth.check('approval/approval_list', current_user)
    	unauthorized 
    	return
    end


    render json: [
	{    
	    'id': 1,
	    'name': '采购',
	    'en_name': 'PurchaseApproval', 
	    
	    'comment': '这是一个采购审批',
	    'created_time': '2017-01-01 08:01:01',
	    'stoped_time': nil,
	    'status': 1
	},
	{    
	    'id': 2,
	    'name': '请假',
	    'en_name': 'LeaveApproval',
	    'group_ids': '11,8,6',
	    'user_ids': '13,50,71,18',
	    'comment': '这是一个请假审批',
	    'created_time': '2017-05-01 08:10:10',
	    'stoped_time': nil,
	    'status': 1     
	},
	{    
	    'id': 3,
	    'name': '付款' ,
	    'en_name': 'PaymentApproval',
	    
	    'comment': '这是一个付款审批',
	    'created_time': '2017-06-01 08:20:20',
	    'stoped_time': nil,
	    'status': 1    
	},
	{    
	    'id': 4,
	    'name': 'xx审批' ,
	    'en_name': 'XxYyZz',
	    
	    'comment': '这是一个xx审批',
	    'created_time': '2017-06-01 08:08:08',
	    'stoped_time': '2017-10-01 08:08:08',
	    'status': 0   
	}
]
  end
end
