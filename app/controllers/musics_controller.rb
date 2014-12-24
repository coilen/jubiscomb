class MusicsController < ApplicationController

  def index
    @musics = Music.eager_load(:details)
  end
end
