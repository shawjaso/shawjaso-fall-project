class CreatePermissions < ActiveRecord::Migration

  def change
    create_table :permissions, :id => false do |t|
      t.integer :link_id
      t.integer :friend_id
    end
  end

end
