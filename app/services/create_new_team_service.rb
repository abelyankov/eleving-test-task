class CreateNewTeamService < SolidService::Base
  def call
    quantity.times do
      team = Team.new(name: Faker::Sports::Football.unique.team)
      team.name = Faker::Sports::Football.unique.team unless team.save!
      team.save!
    end
  end

  def quantity
    params[:quantity]
  end
end
