# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tournament = Tournament.new(name: 'Test', status: :draft)

if tournament.save
  16.times do |i|
    Participant.create!(team: Team.create!(name: "Participant #{i}"), tournament: tournament)
  end

  start_service = Tournaments::StartService.call(tournament: tournament)
  if start_service.success?
    division1_service = Games::DivisionService.call(tournament: tournament, division: 1, status: :division)
    division2_service = Games::DivisionService.call(tournament: tournament, division: 2, status: :division)
  end
end

