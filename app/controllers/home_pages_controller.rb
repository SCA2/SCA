class HomePagesController < ApplicationController
  
  before_action :signed_in_admin, except: :index
  before_action :set_slider_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  def index
    @images = SliderImage.order(:id)
    respond_to do |format|
      format.html
      format.csv { render text: @images.to_csv }
    end
  end

  # GET /images/1
  def show
  end

  # GET /images/new
  def new
    @image = SliderImage.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  def create
    @image = SliderImage.new(slider_image_params)
    if @image.save
      redirect_to @image, notice: 'Slider image was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /images/1
  def update
    if @image.update(slider_image_params)
      redirect_to @image, notice: 'Slider image was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /images/1
  def destroy
    @image.destroy
    redirect_to home_url
  end

  def import
    Faq.import(params[:file])
    redirect_to home_url, notice: "Slider images imported."
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slider_image
      @image = SliderImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faq_params
      params.require(:slider_image).permit(:url, :caption)
    end
    
    def signed_in_admin
      unless signed_in? && current_user.admin?
        redirect_to home_url, :notice => "Sorry, admins only!"
      end
    end
    
end
