class SongsController < ApplicationController

  before_action :find_song, only: [:show, :destroy]

  def index
    @songs = Song.all
    render json: @songs
  end

  def create
    @song = Song.create(name: params[:name], tempo: params['tempo'].to_i, time_signature: params[:time_sign])
  end

  def show
    render json: @song, include: {voice: {only: [:id, :notes]}}
  end

  def destroy
    @song.destroy
    head :no_content
  end

  private

  def find_song
    @song = Song.find_by_id(params[:id])
  end
end
