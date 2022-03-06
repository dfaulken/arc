class AddCarNumberToChampionshipDrivers < ActiveRecord::Migration[6.1]
  def change
    add_column :championship_drivers, :car_number, :string
  end
end
