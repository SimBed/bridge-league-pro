class PlayersController < ApplicationController
  before_action :set_player, only: %i[ edit update destroy ]

  def index
    @players = Player.all
  end

  def new
    @player = Player.new
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

    def player_params
      params.require(:player).permit(:name)
    end
end
