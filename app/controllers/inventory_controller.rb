class InventoryController < ApplicationController
  include JsonResponseHelper

  def trade
    message, status = ::ProcessTradeService.new(first_trader_params, second_trader_params).call
    json_response( { message: message }, status)
  end

  private

  def first_trader_params
    params.require(:first_survivor_trader).permit(:survivor_id,
      inventory_attributes: [ :id, :type ])
  end

  def second_trader_params
    params.require(:second_survivor_trader).permit(:survivor_id,
      inventory_attributes: [ :id, :type ])
  end
end
