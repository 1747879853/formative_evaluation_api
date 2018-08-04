class Employee < ApplicationRecord
  belongs_to :local_depart_record,
      foreign_key: "depart_id",
      primary_key: "depart_id"
  has_many :local_time_records,
      foreign_key: "workno",
      primary_key: "workno"

  def birth
    attributes['birth'].try(:strftime, "%Y-%m-%d")
  end
end