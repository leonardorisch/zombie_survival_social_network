class Survivor < ApplicationRecord
  validates :name, :age, :gender, :latitude, :longitude, presence: true 
end
