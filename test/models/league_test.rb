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
require "test_helper"

class LeagueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
