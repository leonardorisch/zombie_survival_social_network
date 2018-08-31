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
  end
end
