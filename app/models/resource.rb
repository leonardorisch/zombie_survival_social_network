class Resource < ApplicationRecord
  belongs_to :survivor

  RESOURCE_NAMESPACE = "Resource::".freeze
  RESOURCE_TYPES = {
    WATER:      "#{RESOURCE_NAMESPACE}Water",
    FOOD:       "#{RESOURCE_NAMESPACE}Food",
    MEDICATION: "#{RESOURCE_NAMESPACE}Medication",
    AMMUNITION: "#{RESOURCE_NAMESPACE}Ammunition"
  }.freeze

  def points
    raise "Not implemented method"
  end
end
