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
      set_final_results if result.success?
    rescue StandardError => e
      fail!(error: e.message)
    end

    def set_final_results
      tournament.reload
      finalists = tournament.participants.order(points: :desc).limit(2)
      tournament.update!(status: :finished, winner: finalists.first, finalist: finalists.last)
    end
  end
end
