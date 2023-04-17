# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Player < ApplicationRecord
  # https://stackoverflow.com/questions/2057210/ruby-on-rails-reference-the-same-model-twice
  has_many :matches_won, class_name: "Match", foreign_key: "winner_id"
  has_many :matches_lost, class_name: "Match", foreign_key: "loser_id"
  # can't work out how to player.leagues
  # has_many :leagues, through: :matches_lost
  has_many :leagues_with_win, through: :matches_won, source: :league
  has_many :leagues_with_loss, through: :matches_lost, source: :league
  validates :name, presence: true, length: {maximum: 20}, uniqueness: {case_sensitive: false}

  def matches
    matches_won + matches_lost
  end

  def leagues
    (leagues_with_win + leagues_with_loss).uniq
  end

  def league_matches(league)
    matches_won.where(league_id: league.id) + matches_lost.where(league_id: league.id)
  end

  def score(league)
    winning_matches = Match.where(winner_id: id).where(league_id: league.id)
    losing_matches = Match.where(loser_id: id).where(league_id: league.id)
    winning_match_scores = winning_matches.sum(:score)
    losing_match_scores = league.loser_scores_zero? ? 0 : losing_matches.sum(:score)
    score = winning_match_scores - losing_match_scores
    score.round(2)
  end
end
