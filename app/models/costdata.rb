class Costdata < ApplicationRecord
  belongs_to :summary

  # validates_presence_of     :money
  # validates_presence_of     :names

	def as_json(options = {})
		h = {}	
		h[:id] = self.id
		h[:names] = self.names
		h[:thing] = self.thing
		h[:money] = self.money
		h[:costids] = self.costids
		h
	end
end