class CreatePics < ActiveRecord::Migration
  def change
    create_table :pics do |t|
      t.references :performance
      t.integer :position

      t.attachment :thumb

      t.timestamps
    end
  end
end
