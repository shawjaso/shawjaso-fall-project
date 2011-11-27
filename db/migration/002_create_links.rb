class CreateLinks < ActiveRecord::Migration

  def change
    create_table :links do |t|
      t.string :link_id
      t.string :poster_id
      t.string :auth_url
      t.string :unauth_url
      t.timestamps
    end
  end

end
