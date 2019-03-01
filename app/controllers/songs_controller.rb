# CRUD for songs
class SongsController < ApplicationController
  before_action :find_song, only: %i[show destroy generate update]

  def index
    @songs = Song.all
    render json: @songs
  end

  def create
    voices = build_voice_array(params[:voices])
    song_params = build_song_data(voices)
    @song = Song.new(song_params)

    if @song.valid? && @song.save
      synth = Sound::Synthesizer.new
      synth.generate_song(@song)

      render json: { success: 'Song recorded', song: @song, status: :ok },
             status: :ok
    else
      render json: { error: 'Validation failed', errors: @song.errors, status: :bad_request },
             status: :bad_request
    end
  end

  def show
    render json: @song
  end

  def update
    if @song&.valid?
      param_voices = update_params_song[:voices].index_by { |voice| voice['id'] }

      @song.update(update_params_song.except('voices'))
      Voice.update(param_voices.keys, param_voices.values)

      render json: { success: 'Song recorded', song: @song, status: :ok },
             status: :ok
    else
      render json: { error: 'Validation failed, record not updated', errors: @song.errors, status: :bad_request },
             status: :bad_request
    end
  end

  def destroy
    @song.destroy
    render json: { success: 'Song deleted correctly', status: :ok }, status: :ok
  end

  def generate
    synth = Sound::Synthesizer.new
    synth.generate_song(@song)

    if File.exist?(synth.output_file)
      render json: { success: 'Song generated correctly', song: @song, status: :ok },
             status: :ok
    else
      render json: { success: 'There was an issue generating the song', status: :internal_server_error },
             status: :internal_server_error
    end
  end

  private

  def find_song
    @song = Song.find_by_id(params[:id])
  end

  def update_params_song
    params.require(:song).permit(:name, :tempo, :time_signature, voices: %i[id notes note_durations wave_type])
  end

  def build_song_data(voices)
    {
      name: params[:name],
      tempo: params['tempo'].to_i,
      time_signature: params[:time_signature],
      voices: voices
    }
  end

  def build_voice_array(voices = [])
    voices.map do |voice|
      notes, note_durations = Voice.parse_notes(voice[:notes])
      Voice.new(
        notes: notes,
        note_durations: note_durations,
        wave_type: voice[:wave_type]
      )
    end
  end
end
