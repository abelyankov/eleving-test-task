# frozen_string_literal: true

module Games
  # GameDestroyService
  class DestroyService < MainService
    def call
      return fail!(error: 'Tournament finished') if game.tournament.finished?
      return fail!(error: 'Tournament did not started') if game.tournament.draft?

      if game.destroy
        update_points(game.home, home_points)
        update_points(game.away, away_points)
      end
    rescue StandardError => e
      fail!(error: e.message)
    else
      success!
    end

    private

    def game
      params[:game]
    end

    def away_points
      params[:away_points]
    end

    def home_points
      params[:home_points]
    end

    def update_points(participant, points)
      participant.update!(points: participant.points - points)
    end
  end
end
