class Outing < ApplicationRecord
  has_many :suggestions
  has_many :user_outings
  has_many :users, through: :user_outings

  def timer_formatted
    time = time_left.abs
    hours = time / 3600
    time = time - (hours * 3600)
    minutes = time / 60
    time =- time - (minutes * 60)
    "#{hours} hours #{minutes} minutes"
  end

  def voting_over?
    time_left <= 0
  end

  private

  def time_left
    (self.voting_deadline - Time.now).to_i
  end
end
