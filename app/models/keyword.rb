class Keyword < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :type_name, presence: true
end

