# frozen_string_literal: true

module Games
  # PlayoffService
  class PlayoffService < MainService
    def call
      validate_tournament
      unless division_finished?
        return fail!(error: 'You can\'t generate playoff games until all division games are played')
      end
      return fail!(error: 'Playoff games already generated') if playoff_finished?

      generate_first_playoff_games
      success!
    end

    private

    def tournament
      params[:tournament]
    end

    def participants
      params[:participants]
    end

    def games
      tournament.games
    end

    def generate_first_playoff_games
      while participants.size.positive?
        participants.minmax_by(&:points).each_slice(2) do |home, away|
          create_game(home, away)
        end
      end
    rescue StandardError => e
      fail!(error: e.message)
    end

    def create_game(home, away)
      result = Games::CreateService.call!(away: away, home: home, status: :playoff, tournament: tournament)
      if result.success?
        participants.delete(home)
        participants.delete(away)
      else
        fail!(error: result.error)
      end
    end
  end
end
