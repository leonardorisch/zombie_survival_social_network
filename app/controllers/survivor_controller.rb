class SurvivorController < ApplicationController

  def create
    ActiveRecord::Base.transaction do
      survivor = Survivor.create(survivor_params)
      raise ActionController::BadRequest.new() if survivor.new_record?
      render json: SurvivorSerializer.new(survivor).serialized_json, status: 200
    end
  rescue StandardError => exception
    message = "Failed to create a new survivor #{exception}"
    render json: { message: message }, status: 400
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :latitude, :longitude,
      inventory_attributes: [ :id, :type ])
  end
end
