# frozen_string_literal: true

# teams controller
class TeamsController < ApplicationController
  before_action :set_team, except: %w[index new create]

  def index
    @teams = Team.all
  end

  def show; end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to teams_path, flash: { success: 'Team was successfully created.' }
    else
      render :new
    end
  end

  def edit; end

  def update
    if @team.update(team_params)
      redirect_to teams_path, flash: { success: 'Team was successfully updated.' }
    else
      render :edit
    end
  end

  def destroy
    if @team.destroy
      redirect_to teams_path, flash: { success: 'Team was successfully destroyed.' }
    else
      redirect_to teams_path, flash: { error: @team.errors.full_messages.join(', ') }
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

  def set_team
    @team = Team.find(params[:id])
  end
end
