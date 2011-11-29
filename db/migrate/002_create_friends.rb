class CreateFriends < ActiveRecord::Migration
  
  def change
    create_table :friends do |t|
      t.string :fb_id
      t.string :name
      t.integer :owner_id
      t.timestamps
    end
  end

end
