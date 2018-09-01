class Resource < ApplicationRecord
  belongs_to :survivor

  def points
    raise "Not implemented method"
  end
end
