class Outing < ApplicationRecord
  has_many :suggestions
  has_many :user_outings
  has_many :users, through: :user_outings

  def time_left
    time = (self.voting_deadline - Time.now).to_i.abs
    hours = time / 3600
    time = time - (hours * 3600)
    minutes = time / 60
    time =- time - (minutes * 60)
    "#{hours} hours #{minutes} minutes"
  end
end
