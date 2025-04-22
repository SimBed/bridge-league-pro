require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = Player.new(name: 'Andy')
    @league1 = leagues(:league1)
    @league2 = leagues(:league2)
    @daniel = players(:Daniel)
    @kevin = players(:Kevin)
    @match1 = matches(:match1)
  end

  test 'should be valid' do
    assert @player.valid?
  end

  test 'name should be present' do
    @player.name = '     '
    assert_not @player.valid?
  end

  test '#leagues' do
    assert_equal 2, @daniel.leagues.count
    assert_equal 2, @kevin.leagues.count
  end

  test '#matches_won_in' do
    assert_equal 2, @daniel.matches_won_in(@league1).count
    assert_equal 0, @daniel.matches_won_in(@league2).count
    assert_equal 1, @kevin.matches_won_in(@league1).count
    assert_equal 1, @kevin.matches_won_in(@league2).count
  end

  test '#matches_lost_in' do
    assert_equal 1, @daniel.matches_lost_in(@league1).count
    assert_equal 1, @daniel.matches_lost_in(@league2).count
    assert_equal 2, @kevin.matches_lost_in(@league1).count
    assert_equal 0, @kevin.matches_lost_in(@league2).count
  end

  test '#matches_in' do
    assert_equal 3, @daniel.matches_in(@league1).count
    assert_equal 1, @daniel.matches_in(@league2).count
    assert_equal 3, @kevin.matches_in(@league1).count
    assert_equal 1, @kevin.matches_in(@league2).count
  end

  test '#result' do
    assert_equal({score:15, average_score:5.0}, @daniel.result(@league1, '20 April 2025'))
    assert_equal({score:5.0, average_score:1.7}, @kevin.result(@league1, '15 April 2025'))
  end

  test '#progress' do
    assert_equal({0=>10, 1=>15, 2=>15}, @daniel.progress(@league1))
    assert_equal({0=>0, 1=>0, 2=>5}, @kevin.progress(@league1))
  end

  test '#extreme_score' do
    assert_equal({biggest_win:10, biggest_loss:5}, @daniel.extreme_score(@league1))
    assert_equal({biggest_win:3, biggest_loss:0}, @kevin.extreme_score(@league2))
  end

  # not correct for zero losses, forced to pass
  test '#runs' do
    assert_equal({wins:2, losses:1}, @daniel.runs(@league1))
    assert_equal({wins:1, losses:1}, @kevin.runs(@league2))
  end
end
