class AddArtistToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :artist, :string
  end
end
