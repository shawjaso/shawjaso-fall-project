class CreateLinks < ActiveRecord::Migration

  def change
    create_table :links do |t|
      t.integer :owner_id
      t.string :auth_url
      t.string :unauth_url
      t.timestamps
    end
  end

end
