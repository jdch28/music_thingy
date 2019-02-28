class Song < ApplicationRecord
  has_many :voices, dependent: :delete_all

  validates :name, presence: true
  validates :tempo, numericality: { only_integer: true }
  validates :time_signature, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.name ||= "Song #{SecureRandom.uuid}"
    self.tempo ||= 60
    self.time_signature ||= '4/4'
  end
end
