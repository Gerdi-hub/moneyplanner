class Group < ApplicationRecord
  belongs_to :user
  has_many :memberships
  has_many :users, through: :memberships
  has_many :cashflows, through: :users

end
