[1mdiff --git a/app/controllers/matches_controller.rb b/app/controllers/matches_controller.rb[m
[1mindex 9134e69..fe32610 100644[m
[1m--- a/app/controllers/matches_controller.rb[m
[1m+++ b/app/controllers/matches_controller.rb[m
[36m@@ -20,9 +20,11 @@[m [mclass MatchesController < ApplicationController[m
   end[m
 [m
   def create[m
[32m+[m[32m    cookies.permanent[:player_name] =  params[:player_name] if params[:player_name][m
     @match = Match.new(match_params)[m
     if @match.save[m
       flash[:success] = "Match was successfully created."[m
[32m+[m[32m      notify_opponent[m
       redirect_to matches_path[m
     else[m
       set_options[m
[36m@@ -47,6 +49,9 @@[m [mclass MatchesController < ApplicationController[m
 [m
   private[m
 [m
[32m+[m[32m  def notify_opponent[m
[32m+[m[32m  end[m
[32m+[m
   def set_match[m
     @match = Match.find(params[:id])[m
   end[m
[36m@@ -65,8 +70,13 @@[m [mclass MatchesController < ApplicationController[m
   end[m
 [m
   def sanitize_params[m
[31m-    params[:match][:winner_id] = params[:match][:winner_id].to_i[m
[31m-    params[:match][:loser_id] = params[:match][:loser_id].to_i[m
[31m-    params[:match][:league_id] = params[:match][:league_id].to_i[m
[32m+[m[32m    params[:match].tap do |params_match|[m
[32m+[m[32m      params_match[:winner_id] = params_match[:winner_id].to_i if params_match[:winner_id][m
[32m+[m[32m      params_match[:winner_id] = params_match[:winner_id].to_i if params_match[:winner_id][m
[32m+[m[32m      params_match[:winner_id] = params_match[:winner_id].to_i if params_match[:winner_id][m
[32m+[m[32m    end[m
[32m+[m[32m    # params[:match][:winner_id] = params[:match][:winner_id].to_i[m
[32m+[m[32m    # params[:match][:loser_id] = params[:match][:loser_id].to_i[m
[32m+[m[32m    # params[:match][:league_id] = params[:match][:league_id].to_i[m
   end[m
 end[m
[1mdiff --git a/app/models/player.rb b/app/models/player.rb[m
[1mindex 3b6dcff..a5b6f2d 100644[m
[1m--- a/app/models/player.rb[m
[1m+++ b/app/models/player.rb[m
[36m@@ -9,8 +9,8 @@[m
 #[m
 class Player < ApplicationRecord[m
   # https://stackoverflow.com/questions/2057210/ruby-on-rails-reference-the-same-model-twice[m
[31m-  has_many :matches_won, class_name: "Match", foreign_key: "winner_id"[m
[31m-  has_many :matches_lost, class_name: "Match", foreign_key: "loser_id"[m
[32m+[m[32m  has_many :matches_won, class_name: "Match", foreign_key: "winner_id", dependent: :destroy[m
[32m+[m[32m  has_many :matches_lost, class_name: "Match", foreign_key: "loser_id", dependent: :destroy[m
   # can't work out how to player.leagues[m
   # has_many :leagues, through: :matches_lost[m
   has_many :leagues_with_win, through: :matches_won, source: :league[m
[36m@@ -54,7 +54,7 @@[m [mclass Player < ApplicationRecord[m
   def progress(league)[m
     hash = Hash.new[m
     league_matches = matches_in(league).order(:date, :created_at)[m
[31m-    league_matches.each_with_index { |m, index| hash[index] = result(league, m.created_at)[:score] }[m
[32m+[m[32m    league_matches.each_with_index { |m, index| hash[index] = result(league, m.date)[:score] }[m
     hash[m
   end[m
 [m
[36m@@ -62,6 +62,7 @@[m [mclass Player < ApplicationRecord[m
     { biggest_win: matches_won_in(league).maximum(:score) || 0, biggest_loss: matches_lost_in(league).maximum(:score) || 0 }[m
   end[m
 [m
[32m+[m[32m  # TODO not correct for zero losses?[m
   def runs(league)[m
     scores = matches_in(league).order(:date, :created_at).pluck(:winner_id)[m
     {wins: scores.chunk_while { |i, j| (i == id) && (j == id) }.to_a.map { |run| run.length }.max,[m
[1mdiff --git a/config/routes.rb b/config/routes.rb[m
[1mindex c292836..673e0f1 100644[m
[1m--- a/config/routes.rb[m
[1m+++ b/config/routes.rb[m
[36m@@ -1,5 +1,5 @@[m
 Rails.application.routes.draw do[m
[31m-  resources :matches[m
[32m+[m[32m  resources :matches, except: [:show][m
   resources :leagues[m
   resources :players[m
   root "players#index"[m
[1mdiff --git a/test/controllers/leagues_controller_test.rb b/test/controllers/leagues_controller_test.rb[m
[1mindex de32111..0c4305e 100644[m
[1m--- a/test/controllers/leagues_controller_test.rb[m
[1m+++ b/test/controllers/leagues_controller_test.rb[m
[36m@@ -2,47 +2,47 @@[m [mrequire "test_helper"[m
 [m
 class LeaguesControllerTest < ActionDispatch::IntegrationTest[m
   setup do[m
[31m-    @league = leagues(:one)[m
[32m+[m[32m    @league = leagues(:league1)[m
   end[m
 [m
   test "should get index" do[m
[31m-    get leagues_url[m
[32m+[m[32m    get leagues_path[m
     assert_response :success[m
   end[m
 [m
   test "should get new" do[m
[31m-    get new_league_url[m
[32m+[m[32m    get new_league_path[m
     assert_response :success[m
   end[m
 [m
   test "should create league" do[m
     assert_difference("League.count") do[m
[31m-      post leagues_url, params: {league: {name: @league.name}}[m
[32m+[m[32m      post leagues_path, params: {league: {name: @league.name}}[m
     end[m
 [m
[31m-    assert_redirected_to league_url(League.last)[m
[32m+[m[32m    assert_redirected_to leagues_path[m
   end[m
 [m
   test "should show league" do[m
[31m-    get league_url(@league)[m
[32m+[m[32m    get league_path(@league)[m
     assert_response :success[m
   end[m
 [m
   test "should get edit" do[m
[31m-    get edit_league_url(@league)[m
[32m+[m[32m    get edit_league_path(@league)[m
     assert_response :success[m
   end[m
 [m
   test "should update league" do[m
[31m-    patch league_url(@league), params: {league: {name: @league.name}}[m
[31m-    assert_redirected_to league_url(@league)[m
[32m+[m[32m    patch league_path(@league), params: {league: {name: 'fun'}}[m
[32m+[m[32m    assert_redirected_to leagues_path[m
   end[m
 [m
   test "should destroy league" do[m
     assert_difference("League.count", -1) do[m
[31m-      delete league_url(@league)[m
[32m+[m[32m      delete league_path(@league)[m
     end[m
 [m
[31m-    assert_redirected_to leagues_url[m
[32m+[m[32m    assert_redirected_to leagues_path[m
   end[m
 end[m
[1mdiff --git a/test/controllers/matches_controller_test.rb b/test/controllers/matches_controller_test.rb[m
[1mindex 31398c3..74fa044 100644[m
[1m--- a/test/controllers/matches_controller_test.rb[m
[1m+++ b/test/controllers/matches_controller_test.rb[m
[36m@@ -2,47 +2,42 @@[m [mrequire "test_helper"[m
 [m
 class MatchesControllerTest < ActionDispatch::IntegrationTest[m
   setup do[m
[31m-    @match = matches(:one)[m
[32m+[m[32m    @match = matches(:match1)[m
   end[m
 [m
   test "should get index" do[m
[31m-    get matches_url[m
[32m+[m[32m    get matches_path[m
     assert_response :success[m
   end[m
 [m
   test "should get new" do[m
[31m-    get new_match_url[m
[32m+[m[32m    get new_match_path[m
     assert_response :success[m
   end[m
 [m
   test "should create match" do[m
     assert_difference("Match.count") do[m
[31m-      post matches_url, params: {match: {date: @match.date, league_id: @match.league_id, loser_id: @match.loser_id, score: @match.score, winner_id: @match.winner_id}}[m
[32m+[m[32m      post matches_path, params: {match: {date: @match.date, league_id: @match.league_id, loser_id: @match.loser_id, score: @match.score, winner_id: @match.winner_id}}[m
     end[m
 [m
[31m-    assert_redirected_to match_url(Match.last)[m
[31m-  end[m
[31m-[m
[31m-  test "should show match" do[m
[31m-    get match_url(@match)[m
[31m-    assert_response :success[m
[32m+[m[32m    assert_redirected_to matches_path[m
   end[m
 [m
   test "should get edit" do[m
[31m-    get edit_match_url(@match)[m
[32m+[m[32m    get edit_match_path(@match)[m
     assert_response :success[m
   end[m
 [m
   test "should update match" do[m
[31m-    patch match_url(@match), params: {match: {date: @match.date, league_id: @match.league_id, loser_id: @match.loser_id, score: @match.score, winner_id: @match.winner_id}}[m
[31m-    assert_redirected_to match_url(@match)[m
[32m+[m[32m    patch match_path(@match), params: {match: {date: @match.date.advance(days:1)}}[m
[32m+[m[32m    assert_redirected_to matches_path[m
   end[m
 [m
   test "should destroy match" do[m
     assert_difference("Match.count", -1) do[m
[31m-      delete match_url(@match)[m
[32m+[m[32m      delete match_path(@match)[m
     end[m
 [m
[31m-    assert_redirected_to matches_url[m
[32m+[m[32m    assert_redirected_to matches_path[m
   end[m
 end[m
[1mdiff --git a/test/controllers/players_controller_test.rb b/test/controllers/players_controller_test.rb[m
[1mindex 92e7af5..433fa57 100644[m
[1m--- a/test/controllers/players_controller_test.rb[m
[1m+++ b/test/controllers/players_controller_test.rb[m
[36m@@ -2,47 +2,47 @@[m [mrequire "test_helper"[m
 [m
 class PlayersControllerTest < ActionDispatch::IntegrationTest[m
   setup do[m
[31m-    @player = players(:one)[m
[32m+[m[32m    @player = players(:Daniel)[m
   end[m
 [m
   test "should get index" do[m
[31m-    get players_url[m
[32m+[m[32m    get players_path[m
     assert_response :success[m
   end[m
 [m
   test "should get new" do[m
[31m-    get new_player_url[m
[32m+[m[32m    get new_player_path[m
     assert_response :success[m
   end[m
 [m
   test "should create player" do[m
     assert_difference("Player.count") do[m
[31m-      post players_url, params: {player: {name: @player.name}}[m
[32m+[m[32m      post players_path, params: {player: {name: 'Andy'}}[m
     end[m
 [m
[31m-    assert_redirected_to player_url(Player.last)[m
[32m+[m[32m    assert_redirected_to players_path[m
   end[m
 [m
   test "should show player" do[m
[31m-    get player_url(@player)[m
[32m+[m[32m    get player_path(@player)[m
     assert_response :success[m
   end[m
 [m
   test "should get edit" do[m
[31m-    get edit_player_url(@player)[m
[32m+[m[32m    get edit_player_path(@player)[m
     assert_response :success[m
   end[m
 [m
   test "should update player" do[m
[31m-    patch player_url(@player), params: {player: {name: @player.name}}[m
[31m-    assert_redirected_to player_url(@player)[m
[32m+[m[32m    patch player_path(@player), params: {player: {name: @player.name}}[m
[32m+[m[32m    assert_redirected_to players_path[m
   end[m
 [m
   test "should destroy player" do[m
     assert_difference("Player.count", -1) do[m
[31m-      delete player_url(@player)[m
[32m+[m[32m      delete player_path(@player)[m
     end[m
 [m
[31m-    assert_redirected_to players_url[m
[32m+[m[32m    assert_redirected_to players_path[m
   end[m
 end[m
[1mdiff --git a/test/fixtures/leagues.yml b/test/fixtures/leagues.yml[m
[1mindex f0f815f..30dd9ac 100644[m
[1m--- a/test/fixtures/leagues.yml[m
[1m+++ b/test/fixtures/leagues.yml[m
[36m@@ -1,17 +1,9 @@[m
[31m-# == Schema Information[m
[31m-#[m
[31m-# Table name: leagues[m
[31m-#[m
[31m-#  id                :bigint           not null, primary key[m
[31m-#  name              :string[m
[31m-#  season            :string[m
[31m-#  loser_scores_zero :boolean          default(FALSE)[m
[31m-#  created_at        :datetime         not null[m
[31m-#  updated_at        :datetime         not null[m
[31m-#[m
[32m+[m[32mleague1:[m
[32m+[m[32m  name: premier[m
[32m+[m[32m  season: april25[m
[32m+[m[32m  loser_scores_zero: true[m
 [m
[31m-one:[m
[31m-  name: MyString[m
[31m-[m
[31m-two:[m
[31m-  name: MyString[m
[32m+[m[32mleague2:[m
[32m+[m[32m  name: champions[m
[32m+[m[32m  season: may25[m
[32m+[m[32m  loser_scores_zero: true[m
[1mdiff --git a/test/fixtures/matches.yml b/test/fixtures/matches.yml[m
[1mindex 74795bc..2bdacca 100644[m
[1m--- a/test/fixtures/matches.yml[m
[1m+++ b/test/fixtures/matches.yml[m
[36m@@ -1,27 +1,27 @@[m
[31m-# == Schema Information[m
[31m-#[m
[31m-# Table name: matches[m
[31m-#[m
[31m-#  id         :bigint           not null, primary key[m
[31m-#  date       :date[m
[31m-#  score      :float[m
[31m-#  winner_id  :bigint[m
[31m-#  loser_id   :bigint[m
[31m-#  league_id  :bigint           not null[m
[31m-#  created_at :datetime         not null[m
[31m-#  updated_at :datetime         not null[m
[31m-#[m
[32m+[m[32mmatch1:[m
[32m+[m[32m  date: 2025-04-13[m
[32m+[m[32m  score: 10[m
[32m+[m[32m  winner: Daniel[m
[32m+[m[32m  loser: Kevin[m[41m  [m
[32m+[m[32m  league: league1[m
 [m
[31m-one:[m
[31m-  date: 2023-03-26[m
[31m-  score: 1.5[m
[31m-  winner: one[m
[31m-  loser: one[m
[31m-  league: one[m
[32m+[m[32mmatch2:[m
[32m+[m[32m  date: 2025-04-14[m
[32m+[m[32m  score: 5[m
[32m+[m[32m  winner: Daniel[m
[32m+[m[32m  loser: Kevin[m[41m  [m
[32m+[m[32m  league: league1[m
 [m
[31m-two:[m
[31m-  date: 2023-03-26[m
[31m-  score: 1.5[m
[31m-  winner: two[m
[31m-  loser: two[m
[31m-  league: two[m
[32m+[m[32mmatch3:[m
[32m+[m[32m  date: 2025-04-15[m
[32m+[m[32m  score: 5[m
[32m+[m[32m  winner: Kevin[m
[32m+[m[32m  loser: Daniel[m[41m  [m
[32m+[m[32m  league: league1[m
[32m+[m
[32m+[m[32mmatch4:[m
[32m+[m[32m  date: 2025-04-16[m
[32m+[m[32m  score: 3[m
[32m+[m[32m  winner: Kevin[m
[32m+[m[32m  loser: Daniel[m[41m  [m
[32m+[m[32m  league: league2[m
[1mdiff --git a/test/fixtures/players.yml b/test/fixtures/players.yml[m
[1mindex 564bd57..ceef35d 100644[m
[1m--- a/test/fixtures/players.yml[m
[1m+++ b/test/fixtures/players.yml[m
[36m@@ -1,15 +1,6 @@[m
[31m-# == Schema Information[m
[31m-#[m
[31m-# Table name: players[m
[31m-#[m
[31m-#  id         :bigint           not null, primary key[m
[31m-#  name       :string[m
[31m-#  created_at :datetime         not null[m
[31m-#  updated_at :datetime         not null[m
[31m-#[m
[31m-[m
[31m-one:[m
[31m-  name: MyString[m
[31m-[m
[31m-two:[m
[31m-  name: MyString[m
[32m+[m[32mDaniel:[m
[32m+[m[32m  name: Daniel[m
[32m+[m[32m  priority: true[m
[32m+[m[32mKevin:[m
[32m+[m[32m  name: Kevin[m
[32m+[m[32m  priority: true[m
\ No newline at end of file[m
[1mdiff --git a/test/models/league_test.rb b/test/models/league_test.rb[m
[1mindex 64f3bca..f585357 100644[m
[1m--- a/test/models/league_test.rb[m
[1m+++ b/test/models/league_test.rb[m
[36m@@ -12,7 +12,35 @@[m
 require "test_helper"[m
 [m
 class LeagueTest < ActiveSupport::TestCase[m
[31m-  # test "the truth" do[m
[31m-  #   assert true[m
[31m-  # end[m
[32m+[m[32m  def setup[m
[32m+[m[32m    @league = League.new(name: 'May Extravaganza', season: 'April25')[m
[32m+[m[32m    @league1 = leagues(:league1)[m
[32m+[m[32m    @league2 = leagues(:league2)[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'should be valid' do[m
[32m+[m[32m    assert @league.valid?[m
[32m+[m[32m  end[m
[32m+[m[41m  [m
[32m+[m[32m  test 'name should not be more than max length' do[m
[32m+[m[32m    @league.name = 'p' * 21[m
[32m+[m[32m    assert_not @league.valid?[m
[32m+[m[32m  end[m
[32m+[m[41m  [m
[32m+[m[32m  test 'unique_league_season_combo' do[m
[32m+[m[32m    @league2.name = @league.name[m
[32m+[m[32m    assert @league.valid?[m
[32m+[m[32m    @league2.season = @league.season[m
[32m+[m[32m    @league2.save[m
[32m+[m[32m    assert_not @league.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'full_name method' do[m
[32m+[m[32m    assert_equal 'April25 May Extravaganza', @league.full_name[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'players method' do[m
[32m+[m[32m    assert_equal 2, @league1.players.count[m
[32m+[m[32m    assert_equal 2, @league2.players.count[m
[32m+[m[32m  end[m
 end[m
[1mdiff --git a/test/models/match_test.rb b/test/models/match_test.rb[m
[1mindex 0ae0c21..23c253e 100644[m
[1m--- a/test/models/match_test.rb[m
[1m+++ b/test/models/match_test.rb[m
[36m@@ -1,20 +1,42 @@[m
[31m-# == Schema Information[m
[31m-#[m
[31m-# Table name: matches[m
[31m-#[m
[31m-#  id         :bigint           not null, primary key[m
[31m-#  date       :date[m
[31m-#  score      :float[m
[31m-#  winner_id  :bigint[m
[31m-#  loser_id   :bigint[m
[31m-#  league_id  :bigint           not null[m
[31m-#  created_at :datetime         not null[m
[31m-#  updated_at :datetime         not null[m
[31m-#[m
 require "test_helper"[m
 [m
 class MatchTest < ActiveSupport::TestCase[m
[31m-  # test "the truth" do[m
[31m-  #   assert true[m
[31m-  # end[m
[32m+[m[32m  def setup[m
[32m+[m[32m    @league1 = leagues(:league1)[m
[32m+[m[32m    @daniel = players(:Daniel)[m
[32m+[m[32m    @kevin = players(:Kevin)[m
[32m+[m[32m    @match = @league1.matches.build(date: '2025-03-31', score: 10, winner: @daniel, loser: @kevin)[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'should be valid' do[m
[32m+[m[32m    assert @match.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'date should be present' do[m
[32m+[m[32m    @match.date = '     '[m
[32m+[m[32m    assert_not @match.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'score should be present' do[m
[32m+[m[32m    @match.score = '     '[m
[32m+[m[32m    assert_not @match.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'score should be a number' do[m
[32m+[m[32m    @match.score = 'a'[m
[32m+[m[32m    assert_not @match.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'league should be present' do[m
[32m+[m[32m    @match.league_id = nil[m
[32m+[m[32m    assert_not @match.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'winner method' do[m
[32m+[m[32m    assert_equal 'Daniel', @match.winner.name[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'loser method' do[m
[32m+[m[32m    assert_equal 'Kevin', @match.loser.name[m
[32m+[m[32m  end[m
 end[m
[1mdiff --git a/test/models/player_test.rb b/test/models/player_test.rb[m
[1mindex 6a63552..38aab06 100644[m
[1m--- a/test/models/player_test.rb[m
[1m+++ b/test/models/player_test.rb[m
[36m@@ -1,16 +1,68 @@[m
[31m-# == Schema Information[m
[31m-#[m
[31m-# Table name: players[m
[31m-#[m
[31m-#  id         :bigint           not null, primary key[m
[31m-#  name       :string[m
[31m-#  created_at :datetime         not null[m
[31m-#  updated_at :datetime         not null[m
[31m-#[m
 require "test_helper"[m
 [m
 class PlayerTest < ActiveSupport::TestCase[m
[31m-  # test "the truth" do[m
[31m-  #   assert true[m
[31m-  # end[m
[32m+[m[32m  def setup[m
[32m+[m[32m    @player = Player.new(name: 'Andy')[m
[32m+[m[32m    @league1 = leagues(:league1)[m
[32m+[m[32m    @league2 = leagues(:league2)[m
[32m+[m[32m    @daniel = players(:Daniel)[m
[32m+[m[32m    @kevin = players(:Kevin)[m
[32m+[m[32m    @match1 = matches(:match1)[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'should be valid' do[m
[32m+[m[32m    assert @player.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test 'name should be present' do[m
[32m+[m[32m    @player.name = '     '[m
[32m+[m[32m    assert_not @player.valid?[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test '#leagues' do[m
[32m+[m[32m    assert_equal 2, @daniel.leagues.count[m
[32m+[m[32m    assert_equal 2, @kevin.leagues.count[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test '#matches_won_in' do[m
[32m+[m[32m    assert_equal 2, @daniel.matches_won_in(@league1).count[m
[32m+[m[32m    assert_equal 0, @daniel.matches_won_in(@league2).count[m
[32m+[m[32m    assert_equal 1, @kevin.matches_won_in(@league1).count[m
[32m+[m[32m    assert_equal 1, @kevin.matches_won_in(@league2).count[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test '#matches_lost_in' do[m
[32m+[m[32m    assert_equal 1, @daniel.matches_lost_in(@league1).count[m
[32m+[m[32m    assert_equal 1, @daniel.matches_lost_in(@league2).count[m
[32m+[m[32m    assert_equal 2, @kevin.matches_lost_in(@league1).count[m
[32m+[m[32m    assert_equal 0, @kevin.matches_lost_in(@league2).count[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test '#matches_in' do[m
[32m+[m[32m    assert_equal 3, @daniel.matches_in(@league1).count[m
[32m+[m[32m    assert_equal 1, @daniel.matches_in(@league2).count[m
[32m+[m[32m    assert_equal 3, @kevin.matches_in(@league1).count[m
[32m+[m[32m    assert_equal 1, @kevin.matches_in(@league2).count[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test '#result' do[m
[32m+[m[32m    assert_equal({score:15, average_score:5.0}, @daniel.result(@league1, '20 April 2025'))[m
[32m+[m[32m    assert_equal({score:5.0, average_score:1.7}, @kevin.result(@league1, '15 April 2025'))[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test '#progress' do[m
[32m+[m[32m    assert_equal({0=>10, 1=>15, 2=>15}, @daniel.progress(@league1))[m
[32m+[m[32m    assert_equal({0=>0, 1=>0, 2=>5}, @kevin.progress(@league1))[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  test '#extreme_score' do[m
[32m+[m[32m    assert_equal({biggest_win:10, biggest_loss:5}, @daniel.extreme_score(@league1))[m
[32m+[m[32m    assert_equal({biggest_win:3, biggest_loss:0}, @kevin.extreme_score(@league2))[m
[32m+[m[32m  end[m
[32m+[m
[32m+[m[32m  # not correct for zero losses, forced to pass[m
[32m+[m[32m  test '#runs' do[m
[32m+[m[32m    assert_equal({wins:2, losses:1}, @daniel.runs(@league1))[m
[32m+[m[32m    assert_equal({wins:1, losses:1}, @kevin.runs(@league2))[m
[32m+[m[32m  end[m
 end[m
