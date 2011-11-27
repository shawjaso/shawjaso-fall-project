class CreateFriends < ActiveRecord::Migration
  
  def change
    create_table :friends do |t|
      t.facebook_id
      t.user_name
      t.poster_id
      t.link_id
      t.timestamps
    end
  end

end
