class Bom < ApplicationRecord
  belongs_to :material
  # belongs_to :work_order, through: :material
  has_many :boms_approval_details

  def work_order
    self.material.work_order
  end
end
