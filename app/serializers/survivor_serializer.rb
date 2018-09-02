class SurvivorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
  has_many :inventory, class_name: "Resource"
end
