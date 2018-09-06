class ReportsController < ApplicationController
  include JsonResponseHelper

  def show
    report_data = {
      percentage_infected: survivors_percentage(infected: true),
      percentage_non_infected: survivors_percentage(infected: false),
      average_resources_by_survivor: average_resources_by_survivor,
      lost_points_by_infected: lost_points_by_infected
    }

    json_response(report_data, 200)
  end

  private

  def survivors_percentage(filter)
    survivors_count = Survivor.count
    survivors_infected_count = Survivor.where(filter).count

    ((survivors_infected_count / survivors_count.to_f) * 100).round(1).to_f
  end

  def average_resources_by_survivor
    average = {}
    survivors_count = Survivor.count
    Resource::RESOURCE_TYPES.values.each do |resource_type|
      resources_count = Resource.where(type: resource_type).count
      average[resource_type] = (resources_count / survivors_count.to_f).round(1)
    end
    average
  end

  def lost_points_by_infected
    Resource.joins(:survivor).where('survivors.infected').sum { |resource| resource.points }
  end
end
