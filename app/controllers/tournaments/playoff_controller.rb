# frozen_string_literal: true

module Tournaments
  class PlayoffController < ApplicationController
    before_action :set_tournament

    def index
      playoff_participants

      @games = @tournament.games.status(:playoff)
    end

    def generate
      
      result = PlayoffService.call(tournament: @tournament, participants: playoff_participants)
      if result.success?
        redirect_to tournament_playoff_index_path(@tournament),
                    flash: { success: 'Playoff games were successfully generated.' }
      else
        redirect_to tournament_playoff_index_path(@tournament), flash: { error: result.error }
      end
    end

    def destroy
      game = Game.find(params[:id])
      result = GameDestroyService.call(game: game, home_points: game.home_team_score, away_points: game.away_team_score)
      if result.success?
        redirect_to tournament_playoff_index_path(@tournament), flash: { success: 'Games destroyed' }
      else
        redirect_to tournament_playoff_index_path(@tournament), flash: { error: result.error }
      end
    end

    private
    def set_tournament
      @tournament = Tournament.includes(:games, participants: :team).find(params[:tournament_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tournaments_path, flash: { error: 'Tournament not found' }
    end

    def playoff_participants
      participants1 = @tournament.participants.division(:division1).order(points: :desc).limit(4)
      participants2 = @tournament.participants.division(:division2).order(points: :desc).limit(4)
      @playoff_participants ||= (participants1 + participants2).sort_by(&:points).reverse
    end
  end
end
