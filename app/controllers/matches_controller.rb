class MatchesController < ApplicationController
  before_action :sanitize_params, only: [:create, :update]
  before_action :set_match, only: %i[edit update destroy]
  # after_action :set_options, only: %i[new edit]

  def index
    handle_selection
    # @matches = Match.includes(:winner, :loser, :league).order_by_date
    crude_login
    set_selections
    handle_index_response
  end

  def new
    @match = Match.new
    set_options
  end

  def edit
    set_options
  end

  def create
    # cookies.permanent[:player_name] = params[:player_name] if params[:player_name]
    @match = Match.new(match_params)
    if @match.save
      flash[:success] = "Match was successfully created."
      # notify_opponent
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

  def filter
    clear_session(:league)
    session[:league] = params[:league] || session[:league]
    redirect_to matches_path
  end

  private

  # def notify_opponent
  # end

  def set_match
    @match = Match.find(params[:id])
  end

  def set_options
    @player_options = Player.order_by_priority_name.map { |player| [player.name, player.id] }
    @league_options = League.order_by_created_at.map { |league| [league.full_name, league.id] }
    @date_default =  @match.new_record? ? Time.zone.today : @match.date
    @winner_default = @match.new_record? ? Player.find_by(name: cookies[:player_name]).try(:id) : @match.winner.id
    @loser_default = @match.new_record? ? Player.find_by(name: cookies[:player_name]).try(:id) : @match.loser.id
    @league_default = @match.new_record? ? League.find_by(name: cookies[:league_name]).try(:id) : @match.league.id
  end

  def handle_selection
    session[:league] = session[:league] || League.order_by_created_at.first.id
    @matches = Match.where(league_id: session[:league].to_i).order_by_date.includes(:winner, :loser, :league)
  end

  def crude_login
    # eg set cookies for new match from defaults by /matches?player_name=SimBed;league_name=Bridge
    cookies.permanent[:player_name] =  params[:player_name] if params[:player_name]
    cookies.permanent[:league_name] =  params[:league_name] if params[:league_name]
  end

  def set_selections
    @league_options = League.order_by_created_at.map { |league| [league.full_name, league.id] }
  end

  def handle_index_response
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def match_params
    params.require(:match).permit(:date, :score, :winner_id, :loser_id, :league_id)
  end

  def sanitize_params
    params[:match].tap do |params_match|
      params_match[:winner_id] = params_match[:winner_id].to_i if params_match[:winner_id]
      params_match[:winner_id] = params_match[:winner_id].to_i if params_match[:winner_id]
      params_match[:winner_id] = params_match[:winner_id].to_i if params_match[:winner_id]
    end
    # params[:match][:winner_id] = params[:match][:winner_id].to_i
    # params[:match][:loser_id] = params[:match][:loser_id].to_i
    # params[:match][:league_id] = params[:match][:league_id].to_i
  end
end
