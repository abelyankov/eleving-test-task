# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tournaments::StartService, type: :service do
  context '#call' do
    let (:in_progress_tournament) { Tournament.create(name: 'test_in_progress', status: 1) }
    let (:finished_tournament) { Tournament.create(name: 'test_finished', status: 2)}
    let (:draft_tournament) { Tournament.create(name: 'test_draft', status: 0) }

    it 'should not start if tournament in progress' do
      result = described_class.call(tournament: in_progress_tournament)
      expect(result.error).to eq('Tournament is already started')
    end

    it 'should not start if tournament finished' do
      result = described_class.call(tournament: finished_tournament)
      expect(result.error).to eq('Tournament is already finished')
    end

    it 'should start if tournament draft' do
      result = described_class.call(tournament: draft_tournament)
      expect(result.error).to eq('Tournament has no participants')
    end

    it 'should start if tournament draft' do
      16.times do |i|
        team = Team.create(name: "test_#{i}")
        Participant.create(team: team, tournament_id: draft_tournament.id)
      end
      
      result = described_class.call(tournament: draft_tournament)

      expect(result.success?).to eq(true)
      expect(draft_tournament.reload.status).to eq('in_progress')
      expect(draft_tournament.participants.where(division: 'division1').count).to eq(8)
      expect(draft_tournament.participants.where(division: 'division2').count).to eq(8)
    end
  end
end
