class Order < ApplicationRecord
  has_many :work_orders
  has_many :materials, through: :work_orders
  has_many :boms, through: :work_orders

  def as_json(option = {})
  	h = super(option)
  	h[:record_time] = self.record_time.strftime("%Y-%d-%m %H:%M:%S").to_s
  	h
  end
end
