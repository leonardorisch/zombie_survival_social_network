FactoryBot.define do
  factory :resource do
    survivor
  end

  factory :water_resource, parent: :resource, class: 'Resource::Water'
  factory :food_resource, parent: :resource, class: 'Resource::Food'
  factory :medication_resource, parent: :resource, class: 'Resource::Medication'
  factory :ammunition_resource, parent: :resource, class: 'Resource::Ammunition'
end
