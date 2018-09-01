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

    factory :survivor_with_resource do
      after(:create) do |survivor, evaluator|
        create_list(:resource, 2, survivor: survivor)
      end
    end
  end
end
