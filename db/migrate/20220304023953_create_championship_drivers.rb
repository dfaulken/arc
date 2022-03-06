class CreateChampionshipDrivers < ActiveRecord::Migration[6.1]
  def change
    create_table :championship_drivers do |t|
      t.integer :championship_id
      t.integer :driver_id

      t.timestamps
    end
  end
end
