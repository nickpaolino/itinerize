class User < ApplicationRecord
  has_many :likes
  has_many :suggestions
  has_many :user_outings
  has_many :outings, through: :user_outings

  has_secure_password

  validates :username, presence: true
  validates :username, uniqueness: true
end
