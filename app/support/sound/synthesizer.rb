module Sound
  # Sound synth that generates a .wav file from a list of notes: Sound::Synthesizer.new.generate_song <song>
  # Based on https://github.com/jstrait/nanosynth/blob/master/nanosynth.rb
  class Synthesizer
    include Sound::NoteHelper
    include Sound::WavefileHelper

    SAMPLE_RATE = 44_100
    MAX_AMPLITUDE = 0.5
    TWO_PI = 2 * Math::PI

    def generate_song(song)
      @tempo = song.tempo
      @time_signature = song.time_signature
      @output_file = create_output_file_path(song.name)

      samples = []

      song.voices.each do |voice|
        samples << get_data_for_buffer(voice)
      end

      final_samples = process_samples(samples)
      write_file(@output_file, final_samples, SAMPLE_RATE)
    end

    private

    def get_data_for_buffer(voice)
      samples = []
      notes = voice.notes.split(',')
      note_durations = voice.note_durations.split(',')
      notes.each_with_index do |note, index|
        samples << samples_for_note(note, note_durations[index], voice.wave_type)
      end
      samples.flatten
    end

    def samples_for_note(note, note_duration, wave_type)
      note_duration_in_seconds = get_note_duration(note_duration, @tempo, @time_signature)
      number_of_samples = SAMPLE_RATE * note_duration_in_seconds
      frequency = generate_note_frequency(note)
      generate_sample_data(wave_type, number_of_samples, frequency)
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
  end
end
