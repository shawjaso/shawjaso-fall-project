class Link < ActiveRecord::Base

  validates :owner_id, :auth_url, :unauth_url, :presence => true
  has_many :friends, :through => :permissions
  belongs_to :owner

end

