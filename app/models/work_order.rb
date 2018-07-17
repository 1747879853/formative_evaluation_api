class WorkOrder < ApplicationRecord
  belongs_to :order
  has_many :materials
  has_many :boms, through: :materials
end
