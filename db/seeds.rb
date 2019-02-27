# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Song.create(name: "Tan tantan tan", tempo: 120, time_signature: "4/4")
Voice.create(notes: "C4, D4, E4, F4, G4, A4, B4, C5", note_duration: "1, 2, 4, 4, 1, 2, 8, 8", wave_type: "square", song_id: 1)
