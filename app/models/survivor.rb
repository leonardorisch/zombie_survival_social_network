class Survivor < ApplicationRecord
  validates :name, :age, :gender, :latitude, :longitude, presence: true
  has_many :inventory, class_name: 'Resource'
end
