# frozen_string_literal: true

module Tournaments
  # division games controller
  class DivisionGamesController < ApplicationController
    before_action :set_tournament

    def index
      @games = @tournament.games.status(:division)
    end

    def generate
      result = DivisionGamesService.call(tournament: @tournament, division: params[:division], status: :division)
      if result.success?
        redirect_to tournament_division_games_path(@tournament), flash: { success: 'Games generated' }
      else
        redirect_to tournament_division_games_path(@tournament), flash: { error: result.error }
      end
    end

    def destroy
      game = Game.find(params[:id])
      result = GameDestroyService.call(game: game, home_points: game.home_team_score, away_points: game.away_team_score)
      if result.success?
        redirect_to tournament_division_games_path(@tournament), flash: { success: 'Games destroyed' }
      else
        redirect_to tournament_division_games_path(@tournament), flash: { error: result.error }
      end
    end

    private

    def set_tournament
      @tournament = Tournament.find(params[:tournament_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tournaments_path, flash: { error: 'Tournament not found' }
    end

    def update_points(participant, points)
      participant.update(points: participant.points - points)
    end
  end
end
