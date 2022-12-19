# frozen_string_literal: true

module Participants
  # GenerateService
  class GenerateService < ::SolidService::Base
    MAX_PARTICIPANTS = 16

    def call
      return fail!(error: 'Tournament should be present') unless tournament.present?
      return fail!(error: 'Tournament finished') if tournament.finished?
      return fail!(error: 'Tournament should be draft to generate participants') unless tournament.draft?

      if tournament_participants.count == MAX_PARTICIPANTS
        return fail!(error: 'Tournament already has all participants')
      end

      generate_participants
      success!
    end

    private

    def tournament
      params[:tournament]
    end

    def tournament_participants
      tournament.participants
    end

    def tournament_teams
      tournament.teams
    end

    def generate_participants
      genereate_new_team

      missing_participant_quantity = MAX_PARTICIPANTS - tournament_participants.count
      teams = Team.where.not(id: tournament_teams.ids).limit(missing_participant_quantity)

      teams.each do |team|
        Participant.create!(tournament: tournament, team: team)
      end
    rescue StandardError => e
      fail!(error: e.message)
    end

    def genereate_new_team
      team_size = Team.all.size
      return if team_size >= MAX_PARTICIPANTS

      Teams::CreateService.call!(quantity: MAX_PARTICIPANTS - team_size)
    end
  end
end
