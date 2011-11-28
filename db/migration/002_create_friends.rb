class CreateFriends < ActiveRecord::Migration
  
  def change
    create_table :friends do |t|
      t.integer :friend_id, option => 'PRIMARY KEY'
      t.string :friend_fb_id
      t.string :friend_name
      t.references :owner_id
      t.timestamps
    end
  end

end
