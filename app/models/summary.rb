 class Summary < ApplicationRecord
  has_many :costdatas
  belongs_to :users
  
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


















