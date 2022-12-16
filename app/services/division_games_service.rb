class DivisionGamesService < SolidService::Base
  DIVISION_GAMES = 28

  def call
    return fail!(error: 'Tournament should be present') unless tournament.present?
    return fail!(error: 'Tournament is not started') unless tournament.in_progress?
    return fail!(error: 'Tournament finished') if tournament.finished?
    return fail!(error: 'Tournament finished') if tournament.participants.empty?
    return fail!(error: 'Games already generated for this division') if division_games_played?

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

  def division_games_played?
    tournament.games.status(:division).division(division).size == DIVISION_GAMES
  end

  def division_generate_groups
    teams = tournament.participants.division(division).to_a
    teams_size = teams.size
    groups = (1...teams_size).map do |r|
      t = teams.dup
      (0...(teams_size/2)).map do |_|
        [t.shift,t.delete_at(-(r % t.size + (r >= t.size * 2 ? 1 : 0)))]
      end
    end
    create_games(groups)
  rescue StandardError => e
    fail!(error: e.message)
  end

  def create_games(groups)
    groups.each do |round|
      round.each do |group|
        home, away = group
        GameCreateService.call(
          away: away,
          home: home,
          status: status,
          division: division,
          tournament: tournament,
          division: division)
      end
    end
  end
end