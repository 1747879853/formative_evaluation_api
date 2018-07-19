class Order < ApplicationRecord
  has_many :work_orders
  has_many :materials, through: :work_orders
  has_many :boms, through: :work_orders
end
