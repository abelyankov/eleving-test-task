# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Participants::GenerateService, type: :service do
  context '#call' do
    let(:tournament) { Tournament.create(name: 'test') }
    let(:draft_tournament) { Tournament.create(name: 'test_draft', status: 0) }
    let(:finished_tournament) { Tournament.create(name: 'test_finished', status: 2) }

    it 'should not generate if tournament is not present' do
      result = described_class.call(tournament: nil)
      expect(result.error).to eq('Tournament should be present')
    end

    it 'should not generate if tournament finished' do
      result = described_class.call(tournament: finished_tournament)
      expect(result.error).to eq('Tournament finished')
    end

    it 'should not generate if tournament not draft' do
      result = described_class.call(tournament: tournament)
      expect(result.error).to eq('Tournament should be draft to generate participants')
    end

    it 'should not generate if tournament already has all participants' do
      16.times do |i|
        team = Team.create(name: "test_#{i}")
        Participant.create(team: team, tournament_id: draft_tournament.id)
      end

      result = described_class.call(tournament: draft_tournament)
      expect(result.error).to eq('Tournament already has all participants')
    end

    it 'should generate if tournament draft' do
      result = described_class.call(tournament: draft_tournament)
      expect(result.success?).to eq(true)
      expect(draft_tournament.reload.participants.count).to eq(16)
    end
  end
end
# rubocop:enable Metrics/BlockLength
