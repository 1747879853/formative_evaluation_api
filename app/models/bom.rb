class Bom < ApplicationRecord
  belongs_to :material
  # belongs_to :work_order, through: :material

  def work_order
    self.material.work_order
  end
end
