module Sound
  # Sound synth that generates a .wav file from a list of notes.
  # call like this: Sound::Synthesizer.new.generate_song <song>
  # Based on https://github.com/jstrait/nanosynth/blob/master/nanosynth.rb
  class Synthesizer
    require 'wavefile'

    REFERENCE_FREQUENCY = 440 # A4 = 440
    SAMPLE_RATE = 44_100
    MAX_AMPLITUDE = 0.5
    TWO_PI = 2 * Math::PI

    def generate_song(song)
      @tempo = song.tempo
      @time_signature = song.time_signature

      # IF WE ADD MORE VOICES, UPDATE THIS PART
      # voice = song.voice.first
      samples = []

      song.voices.each do |voice|
        samples << get_data_for_buffer(voice)
      end

      final_samples = process_samples(samples)

      buffer = WaveFile::Buffer.new(final_samples, WaveFile::Format.new(:mono, :float, SAMPLE_RATE))
      write_file(song.name, buffer)
    end

    private

    def get_data_for_buffer(voice)
      samples = []
      notes = voice.notes.split(',')
      note_durations = voice.note_duration.split(',')
      notes.each_with_index do |note, index|
        samples << samples_for_note(note, note_durations[index], voice.wave_type)
      end
      samples.flatten
    end

    def samples_for_note(note, note_duration, wave_type)
      number_of_samples = SAMPLE_RATE * get_note_duration(note_duration, @tempo, @time_signature)
      frequency = generate_note_frequency(note)
      generate_sample_data(wave_type, number_of_samples, frequency)
    end

    def get_note_duration(note_duration, tempo, time_signature)
      note_duration_dictionary = { 'w' => 1.0, 'h' => 0.5, 'q' => 0.25, '8' => 0.125 }
      time_signature_value = time_signature.split('/').last.to_i
      (60.0 / tempo) * note_duration_dictionary[note_duration] * time_signature_value
    end

    # The basic formula for the frequencies of the notes of the equal tempered scale is given by
    # fn = f0 * (a)n
    #    f0 = the frequency of one fixed note which must be defined.
    #    n = the number of half steps away from the fixed note you are.
    #    fn = the frequency of the note n half steps away.
    #    a = (2)1/12 = the number which when multiplied by itself 12 times equals 2 = 1.059463094359...
    def generate_note_frequency(note)
      half_step_difference = count_half_steps(note)
      magic_number = 2**(1.0 / 12)
      REFERENCE_FREQUENCY * (magic_number**half_step_difference)
    end

    # This takes a full note name (C3, Bb8) and gets the half step difference between the note and A4
    def count_half_steps(note)
      note_reference = {
        'C' => -9,
        'C#' => -8,
        'Db' => -8,
        'D' => -7,
        'D#' => -6,
        'Eb' => -6,
        'E' => -5,
        'F' => -4,
        'F#' => -3,
        'Gb' => -3,
        'G' => -2,
        'G#' => -1,
        'Ab' => -1,
        'A' => 0,
        'A#' => 1,
        'Bb' => 1,
        'B' => 2
      }
      octave_difference = note[-1].to_i - 4
      note_name = note[0..-2]
      note_reference[note_name] + 12 * octave_difference
    end

    def generate_sample_data(wave_type, num_samples, frequency)
      position_in_period = 0.0
      position_in_period_delta = frequency / SAMPLE_RATE
      samples = []

      num_samples.to_i.times do
        samples << get_sample_value(wave_type, position_in_period)
        position_in_period += position_in_period_delta
        position_in_period -= 1.0 if position_in_period >= 1.0
      end
      samples
    end

    def get_sample_value(wave_type, position_in_period)
      case wave_type.to_sym
      when :sine
        Math.sin(position_in_period * TWO_PI) * MAX_AMPLITUDE
      when :square
        position_in_period >= 0.5 ? MAX_AMPLITUDE : -MAX_AMPLITUDE
      when :saw
        ((position_in_period * 2.0) - 1.0) * MAX_AMPLITUDE
      end
    end

    def process_samples(samples)
      samples.transpose.map do |transposed_data|
        transposed_data.inject(:+) / samples.count
      end
    end

    def write_file(name, buffer)
      file_name = name.gsub(/( )/, '_').downcase
      output_file = Rails.root.join("public/downloads/#{file_name}.wav").to_s

      WaveFile::Writer.new(output_file, WaveFile::Format.new(:mono, :float, SAMPLE_RATE)) do |writer|
        writer.write(buffer)
      end
    end
  end
end
