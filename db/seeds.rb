# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

test_songs = [
  Song.create(
    name: 'Lost Woods',
    tempo: 116,
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
  )
]

Voice.create(
  notes: 'E/4,A/4,B/4,E/4,A/4,B/4,E/4,A/4,B/4,E/5,D/5,B/4,C/5,B/4,G/4,E/4',
  note_durations: '8,8,q,8,8,q,8,8,8,8,q,8,8,8,8,h',
  wave_type: 'sine',
  song: test_songs.first
)

# Careless Whisper riff.
Voice.create(
  notes: 'F/4,E/5,D/5,A/4,F/4,E/5,D/5,A/4,F/4,C/5,Bb/4,F/4,D/4,C/5,Bb/4,F/4,Bb/4,A/4,F/4,D/4,Bb/3,A/3,Bb/3,C/4,D/4,E/4,F/4,G/4,A/4',
  note_durations: 'q,q,8,q,q,q,8,q,q,q,8,q,q,q,8,h,q,8,q,q,h,8,8,8,8,8,8,8,h',
  wave_type: 'sine',
  song: test_songs.second
)
# Multiple voices test
Voice.create(
  notes: 'C/4,G/4,A/4,F/4',
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
  notes: 'G/4,D/5,E/5,C/6',
  note_durations: 'q,q,q,q',
  wave_type: 'sine',
  song: test_songs.third
)

Song.includes(:voices).all.each do |song|
  Sound::Synthesizer.new.generate_song(song)
end
