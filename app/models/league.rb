class League < ApplicationRecord
  has_many :matches, dependent: :destroy
end
