class Friend < ActiveRecord::Base

  validates :friend_fb_id, :friend_name, :presence => true

  belongs_to :owner_id

end

