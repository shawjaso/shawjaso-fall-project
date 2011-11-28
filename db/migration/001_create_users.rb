class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.integer :owner_id, :options => 'PRIMARY KEY'
      t.string :owner_name
      t.string :owner_fb_id
      t.timestamps
    end
  end

end

