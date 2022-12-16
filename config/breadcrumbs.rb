# frozen_string_literal: true

crumb :tournaments do
  link 'Tournaments', tournaments_path
end

crumb :tournament do |tournament|
  link tournament.name, tournament_path(tournament)
  parent :tournaments
end

crumb :new_tournament do
  link 'New', new_tournament_path
  parent :tournaments
end

crumb :edit_tournament do |tournament|
  link 'Edit', edit_tournament_path(tournament)
  parent :tournaments
end

crumb :participants do |tournament|
  link 'Participants',  tournament_participants_path(tournament)
  parent :tournament, tournament
end

crumb :new_participant do |tournament|
  link 'New participant', new_tournament_participant_path(tournament)
  parent :participants, tournament
end

crumb :division_games do |tournament|
  link 'Division games', tournament_division_games_path(tournament)
  parent :tournament, tournament
end

crumb :playoff do |tournament|
  link 'Playoff', tournament_playoff_index_path(tournament)
  parent :division_games, tournament
end

crumb :quarter_final do |tournament|
  link 'Quarter final', tournament_quarter_final_index_path(tournament)
  parent :playoff, tournament
end

crumb :final do |tournament|
  link 'Final', tournament_final_index_path(tournament)
  parent :quarter_final, tournament
end

crumb :teams do
  link 'Teams', teams_path
end

crumb :team do |team|
  link team.name, team_path(team)
  parent :teams
end

crumb :new_team do
  link 'New', new_team_path
  parent :teams
end

crumb :edit_team do |team|
  link 'Edit', edit_team_path(team)
  parent :teams
end
