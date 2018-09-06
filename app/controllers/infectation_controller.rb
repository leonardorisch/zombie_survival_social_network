class InfectationController < ApplicationController
  include JsonResponseHelper

  def report
    survivor_infected = Survivor.find(infectation_params[:infected_id])
    survivor_reporter = Survivor.find(infectation_params[:reporter_id])
    json_response({ message: 'Already infected' }, 200 ) && return if survivor_infected.infected?

    message, status = ProcessInfectationService.new(survivor_infected, survivor_reporter).call
    json_response({ message: message }, status)

  rescue ActiveRecord::RecordNotFound => exception
    json_response({ message: "Infected or reporter not found" }, 404)
  end

  private

  def infectation_params
    params.permit(:reporter_id, :infected_id)
  end
end
