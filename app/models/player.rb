class Player < ApplicationRecord
  # https://stackoverflow.com/questions/2057210/ruby-on-rails-reference-the-same-model-twice
  has_many :matches_won, :class_name => 'Match', foreign_key: 'winner_id'
  has_many :matches_lost, :class_name => 'Match', foreign_key: 'loser_id'
  
  def matches
    matches_won + matches_lost
  end
end
