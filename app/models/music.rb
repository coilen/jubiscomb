# -*- coding: utf-8 -*-
class Music < ActiveRecord::Base
  has_many :details
  has_many :scores, :through => :details

  # ページのデータをMechanizeで取得
  def self.get_html(url)
    agent = Mechanize.new
    agent.get(url)
  end

  # 楽曲データを取得しDBに登録
  def self.get_music_data
    license_music_link =  'http://p.eagate.573.jp/game/jubeat/saucer/p/information/music_list1.html'
    original_music_link =  'http://p.eagate.573.jp/game/jubeat/saucer/p/information/music_list2.html'
    music_urls = [license_music_link, original_music_link]
    music_urls.each do |url|
      html_data = get_html(url)
      html_data_urls = get_url(html_data).flatten
      music_urls << html_data_urls.map { |html_data_url| url + html_data_url }
      music_urls.flatten!

      html_data.search("#music_data li.type0").each do |music_data|
        music = Music.new
        music.title = music_data.search(".name span").text
        artist = music_data.search(".name").text.gsub(/(\s*#{music.title}\s*)|\s{2}/, "")
        music.mid = music_data.children[1].attributes["src"].value.scan(/id(\d*)/)[0][0]
        music.save
        music.details.create(diff: 0, level: music_data.search(".level .bsc").text)
        music.details.create(diff: 1, level: music_data.search(".level .adv").text)
        music.details.create(diff: 2, level: music_data.search(".level .ext").text)
      end
    end
  end

  # 次々にページをたどっていきURLを取得
  def self.get_url(html_data)
    urls = []
    html_data.links.each do |link|
      if link.text == 'next'
        urls.push link.href
        urls.push get_url(link.click)
      end
    end
    urls
  end
end
