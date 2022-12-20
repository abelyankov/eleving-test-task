# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::DestroyService, type: :service do
  context '#call when not finished' do
    let (:tournament) { Tournament.create(name: 'test1', status: 1) }
    let (:participant1) { Participant.create(tournament: tournament, team: Team.create(name: 'test_123'), points: 0) }
    let (:participant2) { Participant.create(tournament: tournament, team: Team.create(name: 'test_321'), points: 0) }
    let (:game) do 
      Games::CreateService.call(tournament: tournament, status: :playoff,
         home: participant1, away: participant2, home_result: 5, away_result: 3).game
    end

    it 'should destroy game' do
      result = described_class.call(game: game, home_points: 5, away_points: 3)

      expect(result.success?).to be_truthy
      expect(participant1.points).to eq(0)
      expect(participant2.points).to eq(0)
    end
  end
end
