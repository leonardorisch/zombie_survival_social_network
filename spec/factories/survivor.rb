FactoryBot.define do
  factory :survivor do
    name { "Human" }
    age { 22 }
    gender { "male" }
    latitude { 156.0011 }
    longitude { 156.0011 }

    factory :survivor_infected do
      infected { true }
    end

    factory :survivor_with_water_resource do
      after(:create) do |survivor, evaluator|
        create_list(:water_resource, 2, survivor: survivor)
      end
    end
    factory :survivor_with_food_resource do
      after(:create) do |survivor, evaluator|
        create_list(:food_resource, 2, survivor: survivor)
      end
    end
    factory :survivor_with_medication_resource do
      after(:create) do |survivor, evaluator|
        create_list(:medication_resource, 2, survivor: survivor)
      end
    end
    factory :survivor_with_ammunition_resource do
      after(:create) do |survivor, evaluator|
        create_list(:ammunition_resource, 2, survivor: survivor)
      end
    end
  end
end
