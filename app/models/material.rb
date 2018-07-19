class Material < ApplicationRecord
  belongs_to :work_order
  has_many :boms
end
