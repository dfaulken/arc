class CreateScores < ActiveRecord::Migration[6.1]
  def change
    create_table :scores do |t|
      t.integer :race_result_id
      t.integer :points_system_id
      t.integer :score

      t.timestamps
    end
  end
end
