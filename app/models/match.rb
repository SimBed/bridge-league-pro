class Match < ApplicationRecord
  belongs_to :winner, class_name: "Player"
  belongs_to :loser, class_name: "Player"
  belongs_to :player
  belongs_to :league
end
