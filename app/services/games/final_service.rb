# frozen_string_literal: true

module Games
  # FinalService
  class FinalService < MainService
    def call
      validate_tournament
      unless division_finished? && quarter_final_finished? && playoff_finished?
        return fail!(error: 'You can\'t generate final games until previous games final games are played')
      end

      generate_games
      success!
    end

    private

    def tournament
      params[:tournament]
    end

    def participants
      params[:participants]
    end

    def generate_games
      away = participants.first
      home = participants.last
      result = Games::CreateService.call!(away: away, home: home, status: :final, tournament: tournament)
      final_results(result.game) if result.success?
    rescue StandardError => e
      fail!(error: e.message)
    end

    def final_results(game)
      tournament.reload
      tournament.update!(status: :finished, winner: game.winner, finalist: game.loser)
    end
  end
end
