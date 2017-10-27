class User < ApplicationRecord
  has_many :likes
  has_many :suggestions
  has_many :user_outings
  has_many :outings, through: :user_outings

  has_secure_password

  validates :username, presence: true
  validates :username, uniqueness: true

  def most_popular_suggestion
    suggestion_hash = {}

    self.suggestions.each do |suggestion|
      suggestion_hash[suggestion.name] ||= 0
      suggestion_hash[suggestion.name] += suggestion.likes.count
    end

    suggestion_hash.sort_by {|n, s| s}.reverse[0][0]
  end

  def winning_suggestions
    compacted_suggestions = self.suggestions.select {|suggestion| suggestion.outing}.compact

    compacted_suggestions.select {|suggestion| suggestion.outing.top_suggestion == suggestion}
  end
end
