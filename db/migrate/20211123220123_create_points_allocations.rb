class CreatePointsAllocations < ActiveRecord::Migration[6.1]
  def change
    create_table :points_allocations do |t|
      t.integer :points_system_id
      t.integer :position
      t.integer :points

      t.timestamps
    end
  end
end
