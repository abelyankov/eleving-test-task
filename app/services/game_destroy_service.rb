class GameDestroyService < SolidService::Base
  def call
    if game.destroy
      update_points(game.home, away_points)
      update_points(game.away, home_points)
    end
  rescue  StandardError => e
    fail!(error: e.message)
  else
    success!
  end

  private
  def game
    params[:game]
  end

  def away_points
    params[:away_points]
  end

  def home_points
    params[:home_points]
  end

  def update_points(participant, points)
    participant.update!(points: participant.points - points)
  end
end