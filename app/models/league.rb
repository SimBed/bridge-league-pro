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
  # https://stackoverflow.com/questions/5846638/how-to-display-unique-records-from-a-has-many-through-relationship
  has_many :winners,  -> { distinct }, through: :matches
  has_many :losers,  -> { distinct }, through: :matches
  validates :name, presence: true, length: {maximum: 20}
  validate :unique_leaague_season_combo
  default_scope -> { order(created_at: :desc) }

  def full_name
    "#{season} #{name}"
  end

  def players
    # note ran Benchmark tests and about 50x quicker without including unecessary uniq after the pluck(:id)
    winner_ids = winners.pluck(:id).join(',')
    loser_ids = losers.pluck(:id).join(',')
    player_ids = (winner_ids + "," + loser_ids)
    # the weird <<-SQL ... SQL syntax is a heredcoc, think of it as quotation marks
    # https://stackoverflow.com/questions/47893902/how-to-chain-raw-sql-queries-in-rails-or-how-to-return-an-activerecord-relation
    # https://stackoverflow.com/questions/5673269/what-is-the-advantage-of-using-heredoc-in-php         
    # query = <<-SQL
    #   SELECT *
    #   FROM players
    #   WHERE id IN (#{player_ids})
    # SQL
    # Player.select('*').from("(#{query}) AS players")
    Player.select('*').from('players').where(id: player_ids.split(','))
  end

  # def players2
  #   (winners + losers).uniq
  # end

  private
  def unique_leaague_season_combo
    league = League.where(['name = ? and season = ?', name, season]).first
    return if league.blank?

    errors.add(:base, 'A league with this name for this season already exists')
  end
end
