class Music < ActiveRecord::Base
  has_many :details
  has_many :scores, :through => :details
end
