class PlayoffService < SolidService::Base
  ALL_DIVISIONS_GAMES = 56

  def call
    return fail!(error: 'Tournament is not started') unless tournament.in_progress?
    return fail!(error: 'Tournament is finished') if tournament.finished?
    return fail!(error: 'You can\'t generate playoff games until all division games are played') unless division_games_played?
    return fail!(error: 'Playoff games already generated') if playoff_games_played?

    generate_first_playoff_games
    success!
  end

  private

  def tournament
    params[:tournament]
  end

  def participants
    params[:participants]
  end

  def division_games_played?
    tournament.games.status(:division).size == ALL_DIVISIONS_GAMES
  end

  def playoff_games_played?
    tournament.games.status(:playoff).size == 4
  end

  def generate_first_playoff_games
    while participants.size > 0
      participants.minmax_by(&:points).each_slice(2) do |home, away|
        result = GameCreateService.call!(
          away: away,
          home: home,
          status: :playoff,
          tournament: tournament
        )
        participants.delete(home)
        participants.delete(away)
        fail!(error: result.error) unless result.success?
      end
    end
  rescue StandardError => e
    fail!(error: e.message)
  end
end