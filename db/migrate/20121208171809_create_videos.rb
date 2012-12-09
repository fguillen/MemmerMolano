class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :performance, :null => false
      t.string :title, :null => false
      t.attachment :pic
      t.text :script, :null => false
      t.text :text
      t.integer :position, :null => false

      t.timestamps
    end
    add_index :videos, :performance_id
  end
end
