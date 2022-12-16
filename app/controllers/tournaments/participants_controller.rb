# frozen_string_literal: true

module Tournaments
  # tournament participants controller
  class ParticipantsController < ApplicationController
    before_action :set_tournament
    before_action :set_participant, only: :destroy
    def index
      @participants = @tournament.participants.order(points: :desc)
    end

    def new
      @participant = @tournament.participants.build
    end

    def new_team
      @participant = @tournament.participants.build
      @participant.build_team
    end

    def create
      @participant = @tournament.participants.build(participant_params)
      if @participant.save
        redirect_to tournament_participants_path(@tournament)
      else
        render :new
      end
    end

    def destroy
      if @participant.destroy
        redirect_to tournament_participants_path(@tournament),
                    flash: { success: 'Participant was successfully destroyed.' }
      else
        redirect_to tournament_participants_path(@tournament),
                    flash: { error: @participant.errors.full_messages.join(', ') }
      end
    end

    def generate
      result = ParticipantService.call(tournament: @tournament)
      if result.success?
        redirect_to tournament_participants_path(@tournament),
                    flash: { success: 'Participants were successfully generated.' }
      else
        redirect_to tournament_participants_path(@tournament), flash: { error: result.error }
      end
    end

    private

    def set_tournament
      @tournament = Tournament.find(params[:tournament_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to tournaments_path, flash: { error: 'Tournament not found' }
    end

    def participant_params
      params.require(:participant).permit(:team_id, :tournament_id, team_attributes: %i[id name])
    end

    def set_participant
      @participant = Participant.find(params[:id])
    end
  end
end
