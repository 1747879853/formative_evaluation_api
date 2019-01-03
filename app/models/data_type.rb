class DataType < ApplicationRecord
  def as_json(options = {})
    h = {}
    h[:id] = self.id
    h[:name] = self.name
    h
  end
end