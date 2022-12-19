# frozen_string_literal: true

module Games
  # DivisionGamesService
  class DivisionService < MainService
    def call
      validate_tournament
      return fail!(error: 'Games already generated for this division') if division_finished?

      division_generate_groups
    end

    private

    def tournament
      params[:tournament]
    end

    def status
      params[:status]
    end

    def division
      params[:division]
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def division_generate_groups # splitting the team into groups into a group [[team1, team2], [team1, team3], ...]
      teams = tournament.participants.division(division).to_a
      teams_size = teams.size
      groups = (1...teams_size).map do |group|
        teams_dup = teams.dup
        (0...(teams_size / 2)).map do |_|
          [teams_dup.shift, teams_dup.delete_at(-(group % teams_dup.size + (group >= teams_dup.size * 2 ? 1 : 0)))]
        end
      end
      create_games(groups)
    rescue StandardError => e
      fail!(error: e.message)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def create_games(groups)
      groups.each do |first_group_level|
        first_group_level.each do |participant_array|
          home, away = participant_array
          ::Games::CreateService.call(away: away, home: home, status: status, division: division, tournament: tournament)
        end
      end
    end
  end
end
