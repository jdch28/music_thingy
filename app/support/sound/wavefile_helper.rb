module Sound
  module WavefileHelper
    def create_output_file_path(name)
      file_name = name.gsub(/[\s-]/, '_').downcase
      Rails.root.join("public/downloads/#{file_name}.wav").to_s
    end

    def write_file(output_file, final_samples, sample_rate)
      buffer = WaveFile::Buffer.new(final_samples, WaveFile::Format.new(:mono, :float, sample_rate))

      WaveFile::Writer.new(output_file, WaveFile::Format.new(:mono, :float, sample_rate)) do |writer|
        writer.write(buffer)
      end
    end
  end
end
