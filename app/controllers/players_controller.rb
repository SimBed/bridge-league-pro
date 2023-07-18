class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  def index
    @players = Player.order_by_priority_name
  end

  def new
    @player = Player.new
  end
  
  def show
    set_league
    @leagues = [['All', nil ,{"data-showurl" => player_path(@player)}]] +
                @player.leagues.map { |l| [l.full_name, l.id, {"data-showurl" => player_url(@player.id, {league_id: l.id})}] }
    @matches = @player.matches_in(@league)
    extreme_scores = @player.extreme_score(@league)
    runs = @player.runs(@league)
    @player_summary = {
      biggest_win: extreme_scores[:biggest_win],
      biggest_loss: extreme_scores[:biggest_loss],
      longest_winning_run: runs[:wins],
      longest_losing_run: runs[:losses]
    }
  end

  def edit
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      flash[:success] = "Player was successfully created."
      redirect_to players_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @player.update(player_params)
      flash[:success] = "Player was successfully updated."
      redirect_to players_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @player.destroy
    flash[:success] = "Player was successfully destroyed."
    redirect_to players_path
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def set_league
    @league = League.find_by(id: params[:league_id]) || 'All'
  end

  def player_params
    params.require(:player).permit(:name, :priority)
  end
end
