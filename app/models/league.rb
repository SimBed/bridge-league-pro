class League < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :winners, through: :matches
  has_many :losers, through: :matches

  def players
    (winners + losers).uniq
  end

  def full_name
    "#{season} #{name}"
  end

end
