class Keyword < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :type_name, presence: true, length: { maximum: 50 }
end

