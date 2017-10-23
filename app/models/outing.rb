class Outing < ApplicationRecord
  has_many :suggestions
  has_many :user_outings
  has_many :users, through: :user_outings
end
