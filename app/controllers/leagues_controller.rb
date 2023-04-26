class LeaguesController < ApplicationController
  before_action :set_league, only: %i[show edit update destroy]

  def index
    @leagues = League.all
  end

  def show
    players = @league.players.to_a
    @players = players.sort_by { |p| -p.result(@league)[:score] }
    # e.g. [["SimKann", 1, {"data-showurl"=>"http://localhost:3000/leagues/1"}],
    #        ["MonNight", 2, {"data-showurl"=>"http://localhost:3000/leagues/2"}]]
    @leagues = League.all.map { |l| [l.full_name, l.id, {"data-showurl" => league_url(l.id)}] }
  end

  def new
    @league = League.new
  end

  def edit
  end

  def create
    @league = League.new(league_params)
    if @league.save
      flash[:success] = "League was successfully created."
      redirect_to leagues_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @league.update(league_params)
      flash[:success] = "League was successfully updated."
      redirect_to leagues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @league.destroy
    flash[:success] = "League was successfully destroyed."
    redirect_to leagues_path
  end

  private

  def set_league
    @league = League.find(params[:id])
  end

  def league_params
    params.require(:league).permit(:season, :name, :loser_scores_zero)
  end
end
