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
  def setup
    @league = League.new(name: 'May Extravaganza', season: 'April25')
    @league1 = leagues(:league1)
    @league2 = leagues(:league2)
  end

  test 'should be valid' do
    assert @league.valid?
  end
  
  test 'name should not be more than max length' do
    @league.name = 'p' * 21
    assert_not @league.valid?
  end
  
  test 'unique_league_season_combo' do
    @league2.name = @league.name
    assert @league.valid?
    @league2.season = @league.season
    @league2.save
    assert_not @league.valid?
  end

  test 'full_name method' do
    assert_equal 'April25 May Extravaganza', @league.full_name
  end

  test 'players method' do
    assert_equal 2, @league1.players.count
    assert_equal 2, @league2.players.count
  end
end
