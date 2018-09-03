class SurvivorController < ApplicationController
  include JsonResponseHelper

  def create
    ActiveRecord::Base.transaction do
      survivor = Survivor.create(survivor_params)
      raise ActionController::BadRequest.new() if survivor.new_record?
      json_response(SurvivorSerializer.new(survivor).serialized_json, 200)
    end
  rescue StandardError => exception
    json_response({ message: "Failed to create a new survivor #{exception}" }, 400)
  end

  def update_location
    survivor = Survivor.find(location_params[:survivor_id])
    survivor.update(location_params.except(:survivor_id))
    json_response({ message: "Survivor updated" }, 200)
  rescue ActiveRecord::RecordNotFound => exception
    json_response({ message: "Survivor not found" }, 422)
  rescue ActiveRecord::RangeError => exception
    json_response({ message: "Fail to update survivor, insert a valid latitude and longitude" }, 400)
  end

  private

  def survivor_params
    params.require(:survivor).permit(:name, :age, :gender, :latitude, :longitude,
      inventory_attributes: [ :id, :type ])
  end

  def location_params
    params.permit(:survivor_id, :latitude, :longitude)
  end
end
