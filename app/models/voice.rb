class Voice < ApplicationRecord
  belongs_to :song

  validates :notes, presence: true
  validates :note_durations, presence: true
  validates :wave_type, presence: true
  validate :validate_notes_to_note_duration_length
  validate :validate_correct_notes
  validate :validate_correct_duration
  validate :validate_wave_type

  private

  VALID_NOTES = ['C', 'C#', 'Db', 'D', 'E', 'F', 'F#',
    'Gb', 'G', 'G#', 'Ab', 'A', 'A#', 'Bb', 'B'
  ]

  VALID_DURATIONS = [
    'w', 'h', 'q', '8'
  ]

  VALID_WAVE_TYPES = [
    'saw', 'sine', 'square'
  ]

  def validate_notes_to_note_duration_length
    if notes.split(',').length != note_durations.split(',').length
      errors.add(:notes, :invalid_length)
    end
  end

  def validate_correct_notes
    notes_array = notes.split(',')
    notes_array.each do |note|
      if VALID_NOTES.exclude?(note[0..-2]) || note[-1].to_i == 0
        errors.add(:notes, :invalid_note)
      end
    end
  end

  def validate_correct_duration
    duration_array = note_durations.split(',')
    duration_array.each do |duration|
      if VALID_DURATIONS.exclude?(duration)
        errors.add(:note_durations, :invalid_duration)
      end
    end
  end

  def validate_wave_type
    if VALID_WAVE_TYPES.exclude?(wave_type)
      errors.add(:wave_type, :invalid_wave_type)
    end
  end
end
