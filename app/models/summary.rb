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
		h
	end
end


















