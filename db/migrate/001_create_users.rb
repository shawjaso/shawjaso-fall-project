class CreateUsers < ActiveRecord::Migration

  def change
    create_table :owners do |t|
      t.string :name
      t.string :fb_id
      t.timestamps
    end
  end

end

