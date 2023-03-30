class LeaguesController < ApplicationController
  before_action :set_league, only: %i[ show edit update destroy ]

  def index
    @leagues = League.all
  end

  def show
  end

  def show
    players = @league.players.to_a
    # p_ord=players.map {|p| p.position(league)}
    # @players = players.sort_by &p_ord.method(:index)
    @players = players.sort_by { |p| -p.score(@league) }
    # e.g. [["SimKann", 1, {"data-showurl"=>"http://localhost:3000/leagues/1"}],
    #        ["MonNight", 2, {"data-showurl"=>"http://localhost:3000/leagues/2"}]]
    @leagues = League.all.map { |l| [l.full_name, l.id, { 'data-showurl' => league_url(l.id) }] }
  end  

  def new
    @league = League.new
  end

  def edit
  end

  def create
    @league = League.new(league_params)
    if @league.save
      redirect_to league_url(@league), notice: "League was successfully created." 
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @league.update(league_params)
      redirect_to league_url(@league), notice: "League was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @league.destroy
    redirect_to leagues_url, notice: "League was successfully destroyed."
  end

  private
    def set_league
      @league = League.find(params[:id])
    end

    def league_params
      params.require(:league).permit(:season, :name, :loser_scores_zero)
    end
end
