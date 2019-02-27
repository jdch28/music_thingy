class CreateVoices < ActiveRecord::Migration[5.2]
  def change
    create_table :voices do |t|
      t.string :notes
      t.string :note_duration
      t.string :wave_type
      t.references :song, foreign_key: true

      t.timestamps
    end
  end
end
