class MatchesController < ApplicationController
  before_action :sanitize_params, only: [:create, :update]
  before_action :set_match, only: %i[ edit update destroy ]
  before_action :set_options, only: %i[new edit]  

  def index
    @matches = Match.all
  end

  def new
    @match = Match.new
  end

   def edit
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      flash[:success] = "Match was successfully created."
      redirect_to matches_path
    else
      set_options
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @match.update(match_params)
      flash[:success] = "Match was successfully updated."
      redirect_to matches_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @match.destroy
    flash[:success] = "Match was successfully destroyed."
    redirect_to matches_path
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def set_options
      @player_options = Player.all.map { |p| [p.name, p.id] }
      @league_options = League.all.map { |l| [l.full_name, l.id] }
    end    

    def match_params
      params.require(:match).permit(:date, :score, :winner_id, :loser_id, :league_id)
    end

    def sanitize_params
      params[:match][:winner_id] =  params[:match][:winner_id].to_i
      params[:match][:loser_id] =  params[:match][:loser_id].to_i
      params[:match][:league_id] =  params[:match][:league_id].to_i
    end    
end