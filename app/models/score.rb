# -*- coding: utf-8 -*-
class Score < ActiveRecord::Base
  belongs_to :detail
  belongs_to :player

  # ページのデータをMechanizeで取得
  def self.get_html(url)
    agent = Mechanize.new
    agent.get(url)
  end

  # 楽曲データを取得しDBに登録
  def self.regist_score_data(rival_id)
    url = "http://jubegraph.dyndns.org/jubeat_saucerfulfill/score.cgi?rid=#{rival_id}"
    player = Player.find_by(rival_id: "#{rival_id}")
    return unless player.id
    html_data = get_html(url)
    score_datas = html_data.search("/html/body/table[2]").search("tr.ce > td")
    score_datas.each_with_index do |score_data, index|
      next if index % 19 != 0 # tr1つにつき 19個要素があるので 1行ずつ見るために飛ばす
      begin
        # p score_data.children[4]
        # p index
        if score_data.children[4].text == ""
          mid = score_data.children[2].children[0].attributes["href"].value.scan(/mid=(\d*)/)[0][0]
        else
          mid = score_data.children[4].children[0].attributes["href"].value.scan(/mid=(\d*)/)[0][0]
        end
      rescue
        next
      end
      next if Music.find_by(mid: mid).blank?
      bsc_score = Score.new; adv_score = Score.new; ext_score = Score.new
      scores = [bsc_score, adv_score, ext_score]
      Music.find_by(mid: mid).details.each do |detail|
        scores[detail.diff].detail_id = detail.id
        p player
        scores[detail.diff].player_id = player.id
      end
      # 点の取得
      [1, 3, 5].each_with_index do |num, score_index|
        scores[score_index].point = score_datas[index + num].text
      end
      # fcの取得
      [2, 4, 6].each_with_index do |num, score_index|
        scores[score_index].fc = fc_check?(score_datas, index + num)
      end
      # 更新日の取得
      [13, 15, 17].each_with_index do |num, score_index|
        scores[score_index].created_at = score_datas[index + num].text.to_time unless score_datas[index + num].text.to_time
      end
      scores.each do |score|
        # p score
        score.save
      end
    end
  end

  def self.fc_check?(score_data, index)
    return false if score_data[index].attributes["class"].value.split[1] == "nofc"
    true
  end
end
