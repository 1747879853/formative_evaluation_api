class  LocalDepartRecord < ApplicationRecord
  has_many :employees,
      foreign_key: "depart_id",
      primary_key: "depart_id"
end