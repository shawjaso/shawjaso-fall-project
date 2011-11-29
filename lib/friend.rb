class Friend < ActiveRecord::Base

  validates :owner_id, :fb_id, :presence => true
  has_many :links, :through => :permissions
  belongs_to :owner

end

