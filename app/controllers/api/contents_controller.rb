module Api
class ContentsController < ApplicationController
  
  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all

    # respond_to do |format|
    #   format.json { render }
    #   format.xml { render xml: @contents }
    # end
    render json: @contents
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])

    render json: @content.to_json(:include => [:photos, :audio])
  end

  # GET /contents/new
  # GET /contents/new.json
  def new
    @content = Content.new

    render json: @content
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(thumbnail_url: content_params[:thumbnail_url], seller: content_params[:seller], phone_number: content_params[:phone_number], 
                                                         price: content_params[:price], location: content_params[:location])
    puts content_params[:photos]
    if @content.save
      content_params[:photos].each do |photo|
        p = Photo.create(photo)
        @content.photos << p
        end
      render json: @content.to_json(:include => [:photos, :audio]), status: :created
    else
      render json: @content.errors, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    @content = Content.find(params[:id])

    if @content.update_attributes(content_params)
      head :no_content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    head :no_content
  end

  def content_params
  	params.require(:content).permit(:thumbnail_url, :seller, :phone_number, :price, :location, :photos => [:small_size_url, :normal_size_url])
  end
end

end