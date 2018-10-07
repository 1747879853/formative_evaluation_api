 class Summary < ApplicationRecord
  belongs_to :user
  has_many :costdatas
  
  validates_presence_of     :date

	def as_json(options = {})
  		h = {}	
		h[:id] = self.id
		h[:date] = self.date
		h[:address] = self.address
		h[:workcontent] = self.workcontent
		h[:transport] = self.transport
		h[:explain] = self.explain
		h[:costdata] = self.costdatas
		h[:workcontentformat] = wcf_str
		h
	end

	def wcf_str
		wf = ""
      	self.workcontent.split('|').each do |item,indexi|
			cnts = item.split(';')
			jic = JobItemContent.find_by(id: cnts[0])
			wf = wf +  (jic ? jic.item_title : "")
			wf = wf + '&nbsp;&nbsp;&nbsp'
			cnts[1].split(',').each do |cnt,indexj|
			  wf = wf + cnt;
			  wf = wf + '&nbsp;&nbsp;&nbsp'
			end
			wf=wf+'</br>'
      	end
      	return wf
	end

	def wcf
		wf_arr = []
      	self.workcontent.split('|').each do |item,indexi|
        
			wf = ""
			cnts = item.split(';')
			jic = JobItemContent.find_by(id: cnts[0])
			wf = wf +  (jic ? jic.item_title : "")
			wf = wf + '&nbsp;&nbsp;&nbsp'
			cnts[1].split(',').each do |cnt,indexj|
			  wf = wf + cnt;
			  wf = wf + '&nbsp;&nbsp;&nbsp'
			end
			wf_arr << wf
      	end
      	return wf_arr
	end

	def self.work_cnt_fmt(wc)
		# workcontent: "19;内容1-质量:1,内容1-时间:2,|20;内容1-时间:3,内容2-质量:4,|"
      
      	wf = ""
      	wc.split('|').each do |item,indexi|
			cnts = item.split(';')
			jic = JobItemContent.find_by(id: cnts[0])
			wf = wf +  (jic ? jic.item_title : "")
			wf = wf + '&nbsp;&nbsp;&nbsp'
			cnts[1].split(',').each do |cnt,indexj|
			  wf = wf + cnt;
			  wf = wf + '&nbsp;&nbsp;&nbsp'
			end
			wf=wf+'</br>'
      	end
      	return wf
    end
end


















