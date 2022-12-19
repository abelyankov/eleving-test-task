# frozen_string_literal: true

module Games
  # MainService
  class MainService < ::SolidService::Base
    DIVISION_GAMES = 28
    ALL_DIVISIONS_GAMES = 56
    PLAYOFF_GAMES = 4
    QUARTER_FINAL_GAMES = 2

    def division_finished?
      tournament.games.status(:division).size == ALL_DIVISIONS_GAMES
    end

    def playoff_finished?
      tournament.games.status(:playoff).size == PLAYOFF_GAMES
    end

    def quarter_final_finished?
      tournament.games.status(:quarter_final).size == QUARTER_FINAL_GAMES
    end

    def validate_tournament
      return fail!(error: 'Tournament should be present') unless tournament.present?
      return fail!(error: 'Tournament finished') if tournament.finished?
      return fail!(error: 'Tournament is not started') unless tournament.in_progress?
    end
  end
end
