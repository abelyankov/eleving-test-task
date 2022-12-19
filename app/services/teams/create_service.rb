# frozen_string_literal: true

module Teams
  # Team::CreateService
  class CreateService < ::SolidService::Base
    MAX_RETRIES_COUNT = 10

    def call
      quantity = params[:quantity] || 0
      retry_count = 0
      return fail!(error: 'Quantity should be present or greater than 0') unless quantity.present? && quantity.positive?

      while quantity.positive?
        unless team.save!
          retry_count += 1
          return fail!(error: 'Too many retries') if retry_count > MAX_RETRIES_COUNT
        end
        quantity -= 1
      end
    end

    private

    def name
      Faker::Games::Zelda.item
    end

    def team
      Team.new(name: name)
    end
  end
end
