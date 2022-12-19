# frozen_string_literal: true

module Games
  # QuarterFinalService
  class QuarterFinalService < MainService
    def call
      validate_tournament
      unless division_finished? && playoff_finished?
        return fail!(error: 'You can\'t generate quarter games until division and playoff games are played')
      end
      return fail!(error: 'Quarter games already generated') if quarter_final_finished?

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
      while participants.size.positive?
        participants.minmax_by(&:points).each_slice(2) do |home, away|
          create_game(home, away)
        end
      end
    rescue StandardError => e
      fail!(error: e.message)
    end

    def create_game(home, away)
      result = Games::CreateService.call!(away: away, home: home, status: :quarter_final, tournament: tournament)
      if result.success?
        participants.delete(home)
        participants.delete(away)
      else
        fail!(error: result.error)
      end
    end
  end
end
