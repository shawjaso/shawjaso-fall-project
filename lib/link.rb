class Link < ActiveRecord::Base

  validates :enabled, :auth_url, :unauth_url, :presence => true

  belongs_to :owner_id

end

