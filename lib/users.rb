class User < ActiveRecord::Base

  validates :owner_name, :owner_fb_id, :presence => true

end

