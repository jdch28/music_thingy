class Voice < ApplicationRecord
  belongs_to :song

  validates :notes, presence: true
  validates :note_durations, presence: true
end
