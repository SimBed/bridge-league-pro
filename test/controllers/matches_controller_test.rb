require "test_helper"

class MatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @match = matches(:match1)
  end

  test "should get index" do
    get matches_path
    assert_response :success
  end

  test "should get new" do
    get new_match_path
    assert_response :success
  end

  test "should create match" do
    assert_difference("Match.count") do
      post matches_path, params: {match: {date: @match.date, league_id: @match.league_id, loser_id: @match.loser_id, score: @match.score, winner_id: @match.winner_id}}
    end

    assert_redirected_to matches_path
  end

  test "should get edit" do
    get edit_match_path(@match)
    assert_response :success
  end

  test "should update match" do
    patch match_path(@match), params: {match: {date: @match.date.advance(days:1)}}
    assert_redirected_to matches_path
  end

  test "should destroy match" do
    assert_difference("Match.count", -1) do
      delete match_path(@match)
    end

    assert_redirected_to matches_path
  end
end
