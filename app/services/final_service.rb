class FinalService < SolidService::Base
  ALL_DIVISIONS_GAMES = 56

  def call
    return fail!(error: 'Tournament is not started') unless tournament.in_progress?
    return fail!(error: 'Tournament is finished') if tournament.finished?
    return fail!(error: 'You can\'t generate playoff games until all division games are played') unless division_games_played?
    return fail!(error: 'You can\'t generate final games until all playoff games are played') unless division_games_played?
    return fail!(error: 'Quarter games not generated yet') unless quarter_final_games_played?

    generate_games
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
    tournament.games.status(:division).size <= ALL_DIVISIONS_GAMES
  end

  def quarter_final_games_played?
    tournament.games.status(:quarter_final).size <= 2
  end

  def generate_games
    away = participants.first
    home = participants.last
    result = GameCreateService.call!(
      away: away,
      home: home,
      status: :final,
      tournament: tournament
    )
    
    if result.success?
      set_final_results
    end
  rescue StandardError => e
    fail!(error: e.message)
  end

  def set_final_results
    tournament.reload
    finalists = tournament.participants.order(points: :desc).limit(2)
    tournament.update!(status: :finished, winner: finalists.first, finalist: finalists.last)
  end
end