module Api
class AudiosController < ApplicationController
  
  # GET /audios
  # GET /audios.json
  def index
    @audios = Audio.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @audios }
    # end
    render json: @audios
  end

  # GET /audios/1
  # GET /audios/1.json
  def show
    @audio = Audio.find(params[:id])

    render json: @audio
  end

  # GET /audios/new
  # GET /audios/new.json
  def new
    @audio = Audio.new

    render json: @audio
  end

  # POST /audios
  # POST /audios.json
  def create
    @audio = Audio.new(audio_params)
    if @audio.save
      @content = Content.find(@audio.content_id)
      @content.audio = @audio
      render json: @audio, status: :created
    else
      render json: @audio.errors, status: :unprocessable_entity
    end
  end


  # DELETE /audios/1
  # DELETE /audios/1.json
  def destroy
    @audio = Audio.find(params[:id])
    @audio.destroy

    head :no_content
  end

  def find_nearby_devices
    nearby_users = Array.new
    #current_audio = Audio.where(latitude: audio_params[:latitude], longtitude: audio_params[:longtitude])
    current_audio = Audio.find(params[:id])
    User.all.each do |user|
      if !user.audios.include? current_audio 
        d = distance [current_audio.latitude, current_audio.longtitude], [user.latitude, user.longtitude]
        user.update_attribute :distance, d
        if d <= 5000
          nearby_users << user
        end
      end
    end
    nearby_users.sort! { |a, b| a.distance <=> b.distance }
    nearby_devices = Array.new
    nearby_users.each do |user|
      nearby_devices << user.device_id
    end
    data = {:key => "value", :key2 => ["array", "value"]}
    GCM.send_notification(nearby_devices[0..49], data)
    render json: nearby_devices[0..49]
  end

  def find_all_devices
    all_devices = User.pluck(:device_id)
    data = {:key => "value", :key2 => ["array", "value"]}
    GCM.send_notification(all_devices, data)
    render json: all_devices
  end

  def find_one_device
    device = params[:device_id]
    audio = Audio.find(params[:id])
    data = {:key => "value", :key2 => ["array", "value"]}
    GCM.send_notification(device, data)
    render json: device
  end

  private

  def distance(a, b)
    if !(a.nil? || b.nil?)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
    dlat_rad = (b[0]-a[0]) * rad_per_deg

    lat1_rad, lon1_rad = a.map! {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = b.map! {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.asin(Math.sqrt(a))

    rm * c # Delta in meters
    end
  end

  def audio_params
    params.require(:audio).permit(:file_url, :duration, :content_id)
  end

end

end