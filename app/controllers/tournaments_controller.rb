# frozen_string_literal: true

# controller
class TournamentsController < ApplicationController
  before_action :set_tournament, except: %w[index new create]

  def index
    @tournaments = Tournament.all
  end

  def show
    if @tournament.draft?
      redirect_to tournament_participants_path(@tournament)
    else
      redirect_to tournament_division_games_path(@tournament)
    end
  end

  def new
    @tournament = Tournament.new
    build_participants(@tournament)
  end

  def create
    @tournament = Tournament.new(tournament_params.merge(status: 0))
    if @tournament.save
      redirect_to tournaments_path, flash: { success: 'Tournament was successfully created.' }
    else
      render :new
    end
  end

  def edit
    build_participants(@tournament)
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to @tournament, flash: { success: 'Tournament was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    if @tournament.destroy
      redirect_to tournaments_url, flash: { success: 'Tournament was successfully destroyed.' }
    else
      redirect_to tournaments_url, flash: { error: @tournament.errors.full_messages.join(', ') }
    end
  end

  def start
    result = Tournaments::StartService.call(tournament: @tournament)
    if result.success?
      redirect_to tournament_division_games_path(@tournament),
                  flash: { success: 'Tournament was successfully started.' }
    else
      redirect_to tournament_participants_path(@tournament), flash: { error: result.error }
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name)
  end

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def build_participants(tournament)
    tournament.participants.build(&:build_team)
  end
end
