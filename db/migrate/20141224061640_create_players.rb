class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :rival_id
      t.string :name
      t.float :jubility

      t.timestamps
    end
  end
end
