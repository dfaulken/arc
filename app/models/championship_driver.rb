class ChampionshipDriver < ApplicationRecord
  belongs_to :championship
  belongs_to :driver

  scope :with_car_number, -> { where.not car_number: nil }

  validates :championship, uniqueness: { scope: :driver, allow_blank: true }
  validates :car_number, format: { with: /\A\d{1,3}\z/, message: 'must contain 1-3 digits' }, allow_blank: true
  validates :car_number, uniqueness: { scope: :championship }

  def car_number_as_integer
    car_number.try(:to_i)
  end

  def numbered_name
    str = driver.name
    if car_number.present?
      str = "##{car_number} #{str}"
    end
    str
  end
end
