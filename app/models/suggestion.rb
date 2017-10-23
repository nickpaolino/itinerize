class Suggestion < ApplicationRecord
  has_many :likes
  belongs_to :user
  belongs_to :outing
end
