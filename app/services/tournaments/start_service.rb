# frozen_string_literal: true

module Tournaments
  # start tournament service
  class StartService < ::SolidService::Base
    MAX_PARTICIPANTS = 16

    def call
      return fail!(error: 'Tournament is already started') if tournament.in_progress?
      return fail!(error: 'Tournament is already finished') if tournament.finished?
      return fail!(error: 'Tournament has no participants') if tournament.participants.count < MAX_PARTICIPANTS

      divide_participants
      update_status
      success!
    end

    private

    def tournament
      params[:tournament]
    end

    def divide_participants
      participants = tournament.participants.shuffle
      participants.each_slice(2).with_index do |(first, second), _index|
        first.update!(division: :division1)
        second.update!(division: :division2)
      end
    end

    def update_status
      tournament.update!(status: :in_progress)
    rescue StandardError => e
      fail!(error: e.message)
    end
  end
end
