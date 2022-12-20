# frozen_string_literal: true

module Games
  # Create game service
  class CreateService < MainService
    def call
      return fail!(error: 'Tournament finished') if tournament.finished?
      return fail!(error: 'Status not valid') unless status.present? && Game.statuses.include?(status)

      if game.save
        update_points(home, home_result)
        update_points(away, away_result)
        success!(game: game)
      else
        fail!(error: game.errors.full_messages.join('; '))
      end
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

    def game
      Game.new(tournament: tournament, home: home, away: away, status: status, division: division,
               home_score: home_result, away_score: away_result)
    end
  end
end
