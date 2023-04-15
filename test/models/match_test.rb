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
require "test_helper"

class MatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
