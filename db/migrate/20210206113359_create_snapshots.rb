class CreateSnapshots < ActiveRecord::Migration[6.0]
  def change
    create_table :snapshots do |t|
      t.string :name
      t.integer :model_id
      t.string :model_type
      t.json :data

      t.timestamps
    end
  end
end
