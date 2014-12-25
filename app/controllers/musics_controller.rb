class MusicsController < ApplicationController

  def index
    @musics = Music.eager_load(:details)
    @players = Player.all 
#    @players = Player.eager_load
  end
end
