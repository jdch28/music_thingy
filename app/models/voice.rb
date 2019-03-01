class Voice < ApplicationRecord
  belongs_to :song

  validates :notes, presence: true
  validates :note_durations, presence: true
  validates :wave_type, presence: true
  validate :validate_notes_to_note_duration_length
  validate :validate_correct_notes
  validate :validate_correct_duration
  validate :validate_wave_type

  after_initialize :set_defaults

  VALID_NOTES = %w[C C# Db D D# E F F# Gb G G# Ab A A# Bb B].freeze
  VALID_DURATIONS = %w[w h q 8 16].freeze
  VALID_WAVE_TYPES = %w[saw sine square].freeze

  def self.parse_notes(note_array)
    notes = []
    durations = []
    note_array.each do |note|
      notes << note[:note]
      durations << note[:duration]
    end
    [notes.join(','), durations.join(',')]
  end

  def as_json(_options = {})
    {
      id: id,
      notes: generate_note_array
    }
  end

  private

  def generate_note_array
    note_array = notes.split(',')
    note_durations_array = note_durations.split(',')
    result = []
    note_array.each_with_index do |note, index|
      result << {
        note: note,
        duration: note_durations_array[index]
      }
    end
    result
  end

  def set_defaults
    self.notes ||= ''
    self.note_durations ||= ''
    self.wave_type ||= 'sine'
  end

  def validate_notes_to_note_duration_length
    errors.add(:notes, :invalid_length) if notes.split(',').length != note_durations.split(',').length
  end

  def validate_correct_notes
    notes_array = notes.split(',')
    notes_array.each do |note|
      note_name, note_octave = note.split('/')
      errors.add(:notes, :invalid_note) unless VALID_NOTES.include?(note_name) && /^\d+$/ =~ note_octave
    end
  end

  def validate_correct_duration
    duration_array = note_durations.split(',')
    duration_array.each do |duration|
      errors.add(:note_durations, :invalid_duration) if VALID_DURATIONS.exclude?(duration)
    end
  end

  def validate_wave_type
    errors.add(:wave_type, :invalid_wave_type) if VALID_WAVE_TYPES.exclude?(wave_type)
  end
end
