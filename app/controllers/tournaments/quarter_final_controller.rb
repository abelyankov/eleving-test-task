# frozen_string_literal: true

module Tournaments
  class QuarterFinalController < ApplicationController
    before_action :set_tournament

    def index
      quarter_final_participants

      @games = @tournament.games.status(:quarter_final)
    end

    def generate
      
      result = QuarterFinalService.call(tournament: @tournament, participants: quarter_final_participants)
      if result.success?
        redirect_to tournament_quarter_final_index_path(@tournament),
                    flash: { success: 'Quarter final were successfully generated.' }
      else
        redirect_to tournament_quarter_final_index_path(@tournament), flash: { error: result.error }
      end
    end

    def destroy
      game = Game.find(params[:id])
      result = GameDestroyService.call(game: game, home_points: game.home_team_score, away_points: game.away_team_score)
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

    def quarter_final_participants
      @quarter_final_participants ||= @tournament.participants.order(points: :desc).limit(4).to_a
    end
  end
end
