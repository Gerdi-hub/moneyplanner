class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :cashflows, dependent: :destroy
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 25 }
end
