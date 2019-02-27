# Tweaked version of https://github.com/jstrait/nanosynth/blob/master/nanosynth.rb
# This should create an ascending+descending cromatic scale from C4 to C5.
# To run:
#       ruby demo/chromatic_thing.rb <wave type>
#       <wave_type> can be sine, square, saw

require 'wavefile'

OUTPUT_FILENAME = './demo/sexy_sounding_thing.wav'.freeze
SAMPLE_RATE = 44_100
SECONDS_TO_GENERATE = 0.25
NUMBER_OF_SAMPLES = SAMPLE_RATE * SECONDS_TO_GENERATE
TWO_PI = 2 * Math::PI
RANDOM_GENERATOR = Random.new
MAX_AMPLITUDE = 0.5
FREQUENCIES = [
  261.6256, # C4
  # 277.1826, # C#4/Db4
  293.6648, # D4
  # 311.1270, # D#4/Eb4
  329.6276, # E4
  349.2282, # F4
  # 369.9944, # F#4/Gb4
  391.9954, # G4
  # 415.3047, # G#4/Ab4
  440.0, # A4
  # 466.1638, # A#4/ Bb4
  493.8833, # B4
  523.2511 # C5
].freeze

def super_awesome_synth
  wave_type = ARGV[0].to_sym # Should be "sine", "square", "saw"

  ascending_buffers = get_wavefile_buffers(wave_type, FREQUENCIES)
  descending_buffers = get_wavefile_buffers(wave_type, FREQUENCIES.reverse[1..])

  # Write the Buffer containing our samples to a monophonic Wave file
  write_file([ascending_buffers, descending_buffers].flatten)
end

def get_wavefile_buffers(wave_type, frequencies)
  wavefile_buffers = []
  frequencies.each do |frequency|
    samples = generate_sample_data(wave_type, NUMBER_OF_SAMPLES, frequency)
    wavefile_buffers.push(WaveFile::Buffer.new(samples, WaveFile::Format.new(:mono, :float, SAMPLE_RATE)))
  end
  wavefile_buffers
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

def write_file(buffers)
  WaveFile::Writer.new(OUTPUT_FILENAME, WaveFile::Format.new(:mono, :pcm_16, SAMPLE_RATE)) do |writer|
    buffers.each do |buffer|
      writer.write(buffer)
    end
  end
end

super_awesome_synth
