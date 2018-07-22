class ApprovalField < ApplicationRecord
  belongs_to :approval

  def self.generateStr(names,ctls,en_name_main="")
  	str=""
  	names.each_with_index  do |nn,i|
  		if ctls[i] == "多行输入框"
  			str = str + nn +":" +"text "
  		elsif ctls[i]== "日期"
  			str = str + nn +":" +"datetime "
  		else
  			str = str + nn +":" +"string "
  		end
  	end
  	if en_name_main != ""
  		str = str + en_name_main.downcase + '_id:' +"integer "
  	end
  	return str

  end
  def self.solid_field_str()
    str = " "
    str = str + "approval_id" +":" +"integer "
    str = str + "approval_name" +":" +"string "
    str = str + "user_id" +":" +"integer "
    str = str + "no" +":" +"string "
    str = str + "submit_time" +":" +"datetime "
    str = str + "finish_time" +":" +"datetime "
    str = str + "procedure_id" +":" +"integer "
    # str = str + "node_ids" +":" +"string "
    # str = str + "role_ids" +":" +"string "
    # str = str + "node_id_now" +":" +"integer "
    # str = str + "submit_to_user_id" +":" +"integer "
    return str
  end
end
