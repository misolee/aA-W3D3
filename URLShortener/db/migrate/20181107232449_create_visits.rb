class CreateVisits < ActiveRecord::Migration[5.1]
  def change
    create_table :visits do |t|
      t.integer :user_id, null: false
      t.integer :shortenedurl_id, null: false
      t.timestamps
    end
    
    add_index :visits, :user_id
    add_index :visits, :shortenedurl_id
  end
end
