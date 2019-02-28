# CRUD for songs
class SongsController < ApplicationController
  before_action :find_song, only: %i[show destroy]

  def index
    @songs = Song.all
    render json: @songs, include: { voices: { only: %i[id notes] } }
  end

  def create
    voices = [
      Voice.new(
        notes: params[:voice][:notes],
        note_durations: params[:voice][:note_duration],
        wave_type: params[:voice][:wave_type]
      )
    ]
    @song = Song.new(
      name: params[:name],
      tempo: params['tempo'].to_i,
      time_signature: params[:time_sign],
      voices: voices
    )
    if @song.valid?
      @song.save
      render json: { success: 'Song recorded', song: @song, status: 200}, include: { voices: { only: %i[id notes] } }, status: 200
    else
      render json: { error: 'Validation failed', errors: @song.errors, status: 400}, status: 400
    end
  end

  def show
    render json: @song, include: { voices: { only: %i[id notes] } }
  end

  def destroy
    @song.destroy
    render json: { success: 'Song deleted correctly', status: 200 }, status: 200
  end

  private

  def find_song
    @song = Song.find_by_id(params[:id])
  end
end
