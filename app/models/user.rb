class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cashflows, dependent: :destroy
  has_many :memberships
  has_many :groups, through: :memberships

  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 25 }
end
