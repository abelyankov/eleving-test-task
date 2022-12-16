class GameCreateService < SolidService::Base
  def call
    game = Game.create!(
      tournament: tournament,
      home: home,
      away: away,
      status: status, division: division,
      home_team_score: home_result,
      away_team_score: away_result
    )
    if game.save
      update_points(home, home_result)
      update_points(away, away_result)
    end
  rescue StandardError => e
    fail!(error: e.message)
  else
    success!
  end

  private
  def tournament
    params[:tournament]
  end

  def away
    params[:away]
  end

  def home
    params[:home]
  end

  def status
    params[:status]
  end

  def division
    params[:division]
  end

  def home_result
    params[:home_result] || Faker::Number.between(from: 1, to: 10)
  end

  def away_result
    params[:away_result] || Faker::Number.between(from: 1, to: 10)
  end

  def update_points(participant, result)
    participant.update!(points: participant.points + result.to_i)
  end
end