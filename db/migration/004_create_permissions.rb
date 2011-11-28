class CreatePermissions < ActiveRecord::Migration

  def change
    create_table :permissions do |t|
      t.reference :link_id
      t.reference :friend_id
    end
  end

end
