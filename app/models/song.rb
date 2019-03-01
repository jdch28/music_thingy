class Song < ApplicationRecord
  include Sound::WavefileHelper

  has_many :voices, dependent: :delete_all

  validates :name, presence: true
  validates :tempo, numericality: { only_integer: true }
  validates :time_signature, presence: true

  after_initialize :set_defaults

  def as_json(_options = {})
    {
      id: id,
      name: name,
      tempo: tempo,
      time_signature: time_signature,
      creation_date: created_at.strftime('%m/%d/%Y'),
      file: sound_file,
      notes: voices.first
    }
  end

  def sound_file
    output_file = create_output_file_path(name)
    File.exist?(output_file) ? output_file : nil
  end

  private

  def set_defaults
    self.name ||= "Song #{SecureRandom.uuid}"
    self.tempo ||= 100
    self.time_signature ||= '4/4'
  end

end
