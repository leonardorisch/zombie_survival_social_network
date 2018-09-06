class ProcessTradeService
  def initialize(first_trader_params, second_trader_params)
    @first_trader_params = first_trader_params
    @first_survivor = Survivor.find(first_trader_params[:survivor_id])
    @second_trader_params = second_trader_params
    @second_survivor = Survivor.find(second_trader_params[:survivor_id])
  end

  def call
    first_resources = resources_by_survivor_params(first_survivor, first_trader_params)
    second_resources = resources_by_survivor_params(second_survivor, second_trader_params)
    except_resources = first_resources.pluck :id
    return "Survivors cannot be infected", 422 if survivors_infected?
    return "Resource values must me equal", 422 if trade_has_different_values?(first_resources, second_resources)
    message, status = process_trade(first_resources, second_resources, except_resources)
    return message, status

  rescue StandardError => exception
    return "Error processing trade #{exception}", 500
  end

  private

  attr_reader :first_trader_params, :second_trader_params
  attr_accessor :first_survivor, :second_survivor

  def resources_by_survivor_params(trader, trader_params)
    resources_type = trader_params[:inventory_attributes].collect{ |resource| resource['type'] }
    trader.inventory.where(type: resources_type)
  end

  def process_trade(first_resources, second_resources, except_resources)
    ActiveRecord::Base.transaction do
      first_resources.update(survivor_id: second_survivor.id)
      second_resources.where.not(id: except_resources).update(survivor_id: first_survivor.id)
      return "Trade done successfully", 200
    end
    return "Resource value have to be equal for trade", 400
  end

  def survivors_infected?
    first_survivor.infected? || second_survivor.infected?
  end

  def trade_has_different_values?(first_resources, second_resources)
    first_resources.sum { |resource| resource.points } != second_resources.sum { |resource| resource.points }
  end

end
