class CreatePerformances < ActiveRecord::Migration
  def self.up
    create_table :performances do |t|
      t.string :title, :null => false
      t.text :text
      t.text :video_script
      t.integer :position, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :performances
  end
end
