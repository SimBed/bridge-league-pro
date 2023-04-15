# == Schema Information
#
# Table name: matches
#
#  id         :bigint           not null, primary key
#  date       :date
#  score      :float
#  winner_id  :bigint
#  loser_id   :bigint
#  league_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
