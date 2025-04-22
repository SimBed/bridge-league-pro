require "test_helper"

class MatchTest < ActiveSupport::TestCase
  def setup
    @league1 = leagues(:league1)
    @daniel = players(:Daniel)
    @kevin = players(:Kevin)
    @match = @league1.matches.build(date: '2025-03-31', score: 10, winner: @daniel, loser: @kevin)
  end

  test 'should be valid' do
    assert @match.valid?
  end

  test 'date should be present' do
    @match.date = '     '
    assert_not @match.valid?
  end

  test 'score should be present' do
    @match.score = '     '
    assert_not @match.valid?
  end

  test 'score should be a number' do
    @match.score = 'a'
    assert_not @match.valid?
  end

  test 'league should be present' do
    @match.league_id = nil
    assert_not @match.valid?
  end

  test 'winner method' do
    assert_equal 'Daniel', @match.winner.name
  end

  test 'loser method' do
    assert_equal 'Kevin', @match.loser.name
  end
end
