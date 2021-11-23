class Driver < ApplicationRecord
  has_many :race_results

  validates :name, presence: true, uniqueness: true
end
