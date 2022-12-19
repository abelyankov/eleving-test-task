# frozen_string_literal: true

module Tournaments
  # final controller
  class FinalController < ApplicationController
    before_action :set_tournament

    def index
      final_participants

      @games = @tournament.games.status(:final)
    end

    def generate
      result = Games::FinalService.call(tournament: @tournament, participants: final_participants)
      if result.success?
        redirect_to tournament_final_index_path(@tournament),
                    flash: { success: 'Final were successfully generated.' }
      else
        redirect_to tournament_final_index_path(@tournament), flash: { error: result.error }
      end
    end

    def destroy
      game = Game.find(params[:id])
      result = GameDestroyService.call(game: game, home_points: game.home_score, away_points: game.away_score)
      if result.success?
        redirect_to tournament_final_index_path(@tournament), flash: { success: 'Games destroyed' }
      else
        redirect_to tournament_final_index_path(@tournament), flash: { error: result.error }
      end
    end

    private

    def set_tournament
      @tournament = Tournament.includes(:games, participants: :team).find(params[:tournament_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tournaments_path, flash: { error: 'Tournament not found' }
    end

    def final_participants
      @final_participants ||= @tournament.participants.order(points: :desc).limit(2)
    end
  end
end
