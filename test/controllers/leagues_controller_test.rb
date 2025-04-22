require "test_helper"

class LeaguesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @league = leagues(:league1)
  end

  test "should get index" do
    get leagues_path
    assert_response :success
  end

  test "should get new" do
    get new_league_path
    assert_response :success
  end

  test "should create league" do
    assert_difference("League.count") do
      post leagues_path, params: {league: {name: @league.name}}
    end

    assert_redirected_to leagues_path
  end

  test "should show league" do
    get league_path(@league)
    assert_response :success
  end

  test "should get edit" do
    get edit_league_path(@league)
    assert_response :success
  end

  test "should update league" do
    patch league_path(@league), params: {league: {name: 'fun'}}
    assert_redirected_to leagues_path
  end

  test "should destroy league" do
    assert_difference("League.count", -1) do
      delete league_path(@league)
    end

    assert_redirected_to leagues_path
  end
end
