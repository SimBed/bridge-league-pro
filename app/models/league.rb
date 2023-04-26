# == Schema Information
#
# Table name: leagues
#
#  id                :bigint           not null, primary key
#  name              :string
#  season            :string
#  loser_scores_zero :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class League < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :winners, through: :matches
  has_many :losers, through: :matches
  validates :name, presence: true, length: {maximum: 20}, uniqueness: {case_sensitive: false}
  default_scope -> { order(created_at: :desc) }

  def players
    (winners + losers).uniq
  end

  def full_name
    "#{season} #{name}"
  end
end
