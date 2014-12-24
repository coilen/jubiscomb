class Score < ActiveRecord::Base
  belongs_to :detail
  belongs_to :player
end
