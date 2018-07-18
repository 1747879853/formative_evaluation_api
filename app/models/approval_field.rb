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
end
