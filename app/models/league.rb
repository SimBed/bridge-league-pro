class League < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :winners, through: :matches
  has_many :losers, through: :matches
  validates :name, presence: true, length: {maximum: 20}, uniqueness: {case_sensitive: false}

  def players
    (winners + losers).uniq
  end

  def full_name
    "#{season} #{name}"
  end
end
