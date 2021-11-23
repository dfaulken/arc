class Championship < ApplicationRecord
  has_many :seasons

  validates :name, presence: true, uniqueness: true
end
