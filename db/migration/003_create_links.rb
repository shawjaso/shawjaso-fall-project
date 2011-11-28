class CreateLinks < ActiveRecord::Migration

  def change
    create_table :links do |t|
      t.integer :link_id, :options => 'PRIMARY KEY'
      t.references :owner_id
      t.boolean :enabled
      t.string :auth_url
      t.string :unauth_url
      t.timestamps
    end
  end

end
