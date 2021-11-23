class Season < ApplicationRecord
  has_many :races
  belongs_to :championship
  belongs_to :points_system
  validates :index, presence: true, uniqueness: { scope: :championship }
  validates :name, presence: true, uniqueness: { scope: :championship }
end
