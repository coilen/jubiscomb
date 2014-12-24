class Detail < ActiveRecord::Base
  belongs_to :music
  has_many :scores
end
