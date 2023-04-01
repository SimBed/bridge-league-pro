class Match < ApplicationRecord
  belongs_to :winner, class_name: "Player"
  belongs_to :loser, class_name: "Player"
  belongs_to :league

  validates :date, presence: true
  validates :score, presence: true, numericality: true
  # belongs_to already triggers validation error if associated record is not present
  # (but present is not the same as present and not nil as I discovered during tests)
  validates :league_id, presence: true
end
