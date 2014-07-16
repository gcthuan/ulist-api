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

    render json: @content
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
    @content = Content.new(content_params)

    if @content.save
      render json: @content, status: :created
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
  	params.require(:content).permit(:thumbnail_url, :seller, :phone_number, :price, :location)
  end
end

end