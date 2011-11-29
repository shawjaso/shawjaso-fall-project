class Owner < ActiveRecord::Base

  validates :name, :fb_id, :presence => true
  has_many :friends
  has_many :links

end

