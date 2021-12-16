class CreateIncidents < ActiveRecord::Migration[6.1]
  def change
    create_table :incidents do |t|
      t.integer :race_id
      t.integer :lap_number
      t.string :reported_by
      t.string :drivers_involved
      t.text :description

      t.timestamps
    end
  end
end
