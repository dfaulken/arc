class AddCarNumberToDrivers < ActiveRecord::Migration[6.1]
  def change
    add_column :drivers, :car_number, :string
  end
end
