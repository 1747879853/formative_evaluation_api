class  LocalTimeRecord < ApplicationRecord
  belongs_to :employee,
      foreign_key: "workno",
      primary_key: "workno"
end