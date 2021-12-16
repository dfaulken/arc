class CreateIncidentOutcomes < ActiveRecord::Migration[6.1]
  def change
    create_table :incident_outcomes do |t|
      t.integer :incident_id
      t.integer :driver_id
      t.boolean :received_warning
      t.integer :penalty_points
      t.datetime :expires_at
      t.text :explanation
      t.boolean :published

      t.timestamps
    end
  end
end
