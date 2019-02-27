class CreateSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :tempo
      t.string :time_signature

      t.timestamps
    end
  end
end
