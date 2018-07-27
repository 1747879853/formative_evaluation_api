class Costdata < ApplicationRecord
  belongs_to :summary

  validates_presence_of     :money
  validates_presence_of     :name

  def as_json(options = {})
		h = {}	
		h[:id] = self.id
		h[:name] = self.name
		h[:thing] = self.thing
		h[:money] = self.money
		h
	end
end