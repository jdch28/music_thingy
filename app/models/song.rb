class Song < ApplicationRecord
  has_many :voice, dependent: :delete_all
  validates :name, presence: true
  validates :tempo, numericality: { only_integer: true }
  validates :time_signature, presence: true
end