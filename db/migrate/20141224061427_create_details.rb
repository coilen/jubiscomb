class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :diff
      t.integer :level
      t.integer :music_id

      t.timestamps
    end
  end
end
