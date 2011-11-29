class Permission < ActiveRecord::Base

  validates :link, :friend, :presence => true
  belongs_to :link
  belongs_to :friend

end
