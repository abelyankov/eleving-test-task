# frozen_string_literal: true

# Game decorator
class GameDecorator < Draper::Decorator
  delegate_all

  def home_team
    if object.home_winner?
      h.content_tag(:strong, object.home&.team&.name)
    else
      h.content_tag(:span, object.home&.team&.name)
    end
  end

  def away_team
    if object.away_winner?
      h.content_tag(:strong, object.away&.team&.name)
    else
      h.content_tag(:span, object.away&.team&.name)
    end
  end
end
