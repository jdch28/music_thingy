# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

test_songs = [
  Song.create(
    name: 'Tan tantan tan',
    tempo: 120,
    time_signature: '4/4'
  ),
  Song.create(
    name: 'Test Song',
    tempo: 170,
    time_signature: '4/4'
  ),
  Song.create(
    name: 'Chord Song',
    tempo: 60,
    time_signature: '4/4'
  ),
  Song.create(
    name: 'Test',
    tempo: 60,
    time_signature: '4/4'
  ),
  Song.create(
    name: 'Chord Song 2',
    tempo: 55,
    time_signature: '4/4'
  )
]

Voice.create(
  notes: 'C4,D4,E4,F4,G4,A4,B4,C5',
  note_durations: 'w,h,q,q,w,h,8,8',
  wave_type: 'square',
  song: test_songs.first
)

# Careless Whisper riff.
Voice.create(
  notes: 'F4,E5,D5,A4,F4,E5,D5,A4,F4',
  note_durations: 'q,q,8,q,q,q,8,q,q',
  wave_type: 'sine',
  song: test_songs.second
)

# Multiple voices test
Voice.create(
  notes: 'C4,G4,A4,F4',
  note_durations: 'q,q,q,q',
  wave_type: 'sine',
  song: test_songs.third
)
Voice.create(
  notes: 'E4,B4,C5,A4',
  note_durations: 'q,q,q,q',
  wave_type: 'sine',
  song: test_songs.third
)
Voice.create(
  notes: 'G4,D5,E5,C6',
  note_durations: 'q,q,q,q',
  wave_type: 'sine',
  song: test_songs.third
)

Voice.create(
  notes: 'F#4',
  note_durations: 'w',
  wave_type: 'sine',
  song: test_songs.fourth
)

# Multiple voices test 2
# Voice.create(
#   notes: 'C4,D4,E4,F4,G4,A4,B4,C5,B4,A4,G4,F4,E4,D4,C4',
#   note_durations: '16,16,16,16,16,16,16,16,16,16,16,16,16,16,8',
#   wave_type: 'sine',
#   song: test_songs.fifth
# )
#
# Voice.create(
#   notes: 'C4',
#   note_durations: 'h',
#   wave_type: 'sine',
#   song: test_songs.fifth
# )
