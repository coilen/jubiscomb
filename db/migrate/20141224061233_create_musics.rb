class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.integer :mid
      t.string :title
      t.string :version
      t.string :event
      t.boolean :hold

      t.timestamps
    end
  end
end
