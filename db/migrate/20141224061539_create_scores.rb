class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :point
      t.boolean :fc
      t.integer :player_id
      t.integer :detail_id

      t.timestamps
    end
  end
end
