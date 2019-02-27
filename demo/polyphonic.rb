# Tweaked version of https://github.com/jstrait/nanosynth/blob/master/nanosynth.rb
# This should create an ascending+descending cromatic scale from C4 to C5.
# To run:
#       ruby demo/polyphonic.rb <wave type>
#       <wave_type> can be sine, square, saw

require 'wavefile'

OUTPUT_FILENAME = './demo/sexy_sounding_thing.wav'.freeze
SAMPLE_RATE = 44_100
SECONDS_TO_GENERATE = 2
NUMBER_OF_SAMPLES = SAMPLE_RATE * SECONDS_TO_GENERATE
TWO_PI = 2 * Math::PI
RANDOM_GENERATOR = Random.new
MAX_AMPLITUDE = 0.5
FREQUENCIES = [
  261.6256, # C4
  # 277.1826, # C#4/Db4
  # 293.6648, # D4
  # 311.1270, # D#4/Eb4
  329.6276, # E4
  # 349.2282, # F4
  # 369.9944, # F#4/Gb4
  391.9954, # G4
  # 415.3047, # G#4/Ab4
  # 440.0, # A4
  466.1638, # A#4/ Bb4
  # 493.8833, # B4
  # 523.2511 # C5
].freeze

def super_awesome_synth
  wave_type = ARGV[0].to_sym # Should be "sine", "square", "saw"

  buffer = get_wavefile_buffer(wave_type, FREQUENCIES)

  # Write the Buffer containing our samples to a monophonic Wave file
  write_file(buffer)
end

def get_wavefile_buffer(wave_type, frequencies)
  samples = []
  frequencies.each do |frequency|
    samples << generate_sample_data(wave_type, NUMBER_OF_SAMPLES, frequency)
  end

  # According to the guy that build wavefile... if you add the samples of each note and devide
  # them between the number of notes, you (somehow) get a chord
  # https://www.joelstrait.com/nanosynth/
  shit_thats_gonna_sound_like_hell = samples.transpose.map { |x| x.reduce(:+) }
  shit_thats_gonna_sound_like_hell = shit_thats_gonna_sound_like_hell.map { |x| x / samples.count }

  WaveFile::Buffer.new(shit_thats_gonna_sound_like_hell, WaveFile::Format.new(:mono, :float, SAMPLE_RATE))
end

def generate_sample_data(wave_type, num_samples, frequency)
  position_in_period = 0.0
  position_in_period_delta = frequency / SAMPLE_RATE
  samples = [].fill(0.0, 0, num_samples)

  num_samples.to_i.times do |i|
    samples[i] = get_sample_value(wave_type, position_in_period)
    position_in_period += position_in_period_delta
    position_in_period -= 1.0 if position_in_period >= 1.0
  end
  samples
end

def get_sample_value(wave_type, position_in_period)
  case wave_type
  when :sine
    Math.sin(position_in_period * TWO_PI) * MAX_AMPLITUDE
  when :square
    position_in_period >= 0.5 ? MAX_AMPLITUDE : -MAX_AMPLITUDE
  when :saw
    ((position_in_period * 2.0) - 1.0) * MAX_AMPLITUDE
  end
end

def write_file(buffer)
  WaveFile::Writer.new(OUTPUT_FILENAME, WaveFile::Format.new(:mono, :float, SAMPLE_RATE)) do |writer|
    writer.write(buffer)
  end
end

super_awesome_synth
