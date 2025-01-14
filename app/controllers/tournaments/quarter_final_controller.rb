# frozen_string_literal: true

module Tournaments
  # quarter final controller
  class QuarterFinalController < ApplicationController
    before_action :set_tournament

    def index
      quarter_final_participants

      games
    end

    def generate
      result = Games::QuarterFinalService.call(tournament: @tournament, participants: quarter_final_participants)
      if result.success?
        redirect_to tournament_quarter_final_index_path(@tournament),
                    flash: { success: 'Quarter final were successfully generated.' }
      else
        redirect_to tournament_quarter_final_index_path(@tournament), flash: { error: result.error }
      end
    end

    def destroy
      game = Game.find(params[:id])
      result = Games::DestroyService.call(game: game, home_points: game.home_score, away_points: game.away_score)
      if result.success?
        redirect_to tournament_quarter_final_index_path(@tournament), flash: { success: 'Games destroyed' }
      else
        redirect_to tournament_quarter_final_index_path(@tournament), flash: { error: result.error }
      end
    end

    private

    def set_tournament
      @tournament = Tournament.includes(:games, participants: :team).find(params[:tournament_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tournaments_path, flash: { error: 'Tournament not found' }
    end

    def games
      @games ||= @tournament.games.status(:quarter_final)
    end

    def playoff_games
      @playoff_games ||= @tournament.games.status(:playoff)
    end

    def quarter_final_participants
      @quarter_final_participants ||= playoff_games.map(&:winner)
    end
  end
end
