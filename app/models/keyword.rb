class Keyword < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 30}
  validates :type_name, presence: true, length: { maximum: 30 }
end

