# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::CreateService, type: :service do
  context '#call when finished' do
    let(:finished_tournament) { Tournament.create(name: 'test1', status: 2) }
    let(:participant1) { Participant.create(tournament: finished_tournament, team: Team.create(name: 'test_12')) }
    let(:participant2) { Participant.create(tournament: finished_tournament, team: Team.create(name: 'test_22')) }

    it 'should not create game if tournament finished' do
      result = described_class.call(tournament: finished_tournament, home: participant1, away: participant2)
      expect(result.error).to eq('Tournament finished')
    end
  end

  context '#call when not finished' do
    let(:tournament) { Tournament.create(name: 'test1', status: 1) }
    let(:participant1) { Participant.create(tournament: tournament, team: Team.create(name: 'test_112')) }
    let(:participant2) { Participant.create(tournament: tournament, team: Team.create(name: 'test_223')) }

    it 'should create game with status playoff' do
      result = described_class.call(tournament: tournament, status: :playoff, home: participant1, away: participant2,
                                    home_result: 5, away_result: 3)
      expect(result.success?).to be_truthy
      expect(result.game.status).to eq('playoff')
      expect(participant1.points).to eq(5)
      expect(participant2.points).to eq(3)
    end
  end
end
